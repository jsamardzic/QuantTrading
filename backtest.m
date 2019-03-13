function error = backtest(strategy,risk_free_return)
error=false;

if nargin < 2
    risk_free_return=0.05;
end

parameters = struct();
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
for k=1:length(parameters.markets)
    f = fopen(strcat(parameters.markets{k}, '.csv'));
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
end
n = length(dates);
retrn=zeros(1,n);

balance=1000;
stocks=0;
bp=0;
bc=balance;

for k=1:(n-1)
    bp=bc;
    [position,~] = strategy(close(1:k), parameters);
    switch (position)
        case 1
            if(balance>0)
                stocks=balance/open(k+1);
                balance=0;
            end
        case -1
            if(stocks>0)
                balance=stocks*open(k+1);
                stocks=0;
            end
    end
    if(balance>0)
        bc=balance;
    end
    if(balance==0)
        bc=stocks*close(k+1);
    end
    retrn(k)=(bc-bp)/bp;
    fprintf("%d\t%d\t%f\t%f\t%f\n", k, position, balance, stocks, retrn(k));
end
if(stocks~=0)
    balance=stocks*close(n);
    stocks=0;
end

[maxd, maxdd] = drawdowns(retrn);
fprintf("Balance: %f\n", balance);
fprintf("Sharpe ratio: %f\n", sharperatio(retrn,risk_free_return));
fprintf("Max drawdown: %f\nMax drawdown duration: %d\n", maxd, maxdd);
end