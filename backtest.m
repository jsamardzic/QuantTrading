function [error,sr] = backtest(strategy,varargin)
error=false;
sr=-Inf;

parameters = struct();
risk_free_return=0.05;
slippage=0.05;
verbose=true;
days_range=[0,1];

while ~isempty(varargin)
    switch lower(varargin{1})
        case 'parameters'
            parameters = varargin{2};
        case 'risk_free_return'
            risk_free_return = varargin{2};
        case 'slippage'
            slippage = varargin{2};
        case 'verbose'
            verbose = varargin{2};
        case 'days_range'
            days_range = varargin{2};
        otherwise
            error=true
            return;
    end
    varargin (1:2)=[];
end

[~,parameters] = strategy([],parameters);
if ~isfield(parameters, 'markets')
    error = true;
    return;
end
if length(parameters.markets)<1
    error=true;
    return;
end

close = [];
open = [];
high = [];
low = [];
for k=1:length(parameters.markets)
    f = fopen(strcat('data/', parameters.markets{k}, '.csv'));
    hist_data = textscan(f, '%s %f %f %f %f %f %f', 'Delimiter', ',', 'HeaderLines', 1);
    fclose(f);
    if k==1
        dates = datenum(hist_data{1});
    else
        if length(hist_data{1})~=length(dates)
            error=true;
            return;
        end
        if ~all(datenum(hist_data{1})==dates)
            error = true;
            return;
        end
    end
    
    close = cat(2, close, hist_data{5});
    open = cat(2, open, hist_data{2});
    high = cat(2, high, hist_data{3});
    low = cat(2, low, hist_data{4});
end

ndays = length(dates);
day_first=floor(days_range(1)*(ndays-1))+1;
day_last=floor(days_range(2)*(ndays-1))+1;
ndays=day_last-day_first+1;
close=close(day_first:day_last,:);
open=open(day_first:day_last,:);
high=high(day_first:day_last,:);
low=low(day_first:day_last,:);
nmarkets = length(parameters.markets);
returns=zeros(1,ndays);

equity=1;
exposure=zeros(nmarkets,1);
exposure_next=zeros(nmarkets,1);

for k=2:ndays
    for l=1:nmarkets
        gap_return=exposure(l)*(open(k,l)-close(k-1,l))/close(k-1,l);
        returns(k)=returns(k)+gap_return;
    end
    
    for l=1:nmarkets
        slippage_return=abs(exposure_next(l)-exposure(l))*slippage*(high(k,l)-low(k,l))/close(k-1,l);
        returns(k)=returns(k)-slippage_return;
    end
    
    exposure=exposure_next;
    
    for l=1:nmarkets
        session_return=exposure(l)*(close(k,l)-open(k,l))/close(k-1,l);
        returns(k)=returns(k)+session_return;
    end
    
    equity_prev=equity;
    equity=(1+returns(k))*equity_prev;
    for l=1:nmarkets
        nstocks=exposure(l)*equity_prev/close(k-1,l);
        exposure(l)=nstocks*close(k,l)/equity;
    end
    
    [positions,~] = strategy(close(1:k,:), parameters);
    if all(positions==0)
        exposure_next=zeros(nmarkets,1);
    else
        exposure_next=positions/(sum(abs(positions)));
    end
end

sr = sharperatio(returns,risk_free_return);
[maxd, maxdd] = drawdowns(returns);
if verbose
    fprintf("Equity: %f\n", equity);
    fprintf("Sharpe ratio: %f\n", sr);
    fprintf("Max drawdown: %f\nMax drawdown duration: %d\n", maxd, maxdd);
end
end