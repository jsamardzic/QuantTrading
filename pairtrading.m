function [positions, parameters] = pairtrading(close,parameters, positions)
if ~isfield(parameters, 'markets')
    parameters.markets = {'GM', 'F', 'JNJ', 'PG'};
end
if ~isfield(parameters, 'm')
    parameters.m=28;
end
if ~isfield(parameters, 'lomark')
    parameters.lomark=-1;
end
if ~isfield(parameters, 'himark')
    parameters.himark=1.8;
end

nmarkets = numel(parameters.markets);
positions_prev = positions;
positions=zeros(nmarkets,1);

if isempty(close)
    return;
end

ndays = size(close,1);
m = parameters.m;
lomark = parameters.lomark;
himark = parameters.himark;

if ndays<m
    return;
end

idx1=ndays-m+1;
idx2=ndays-1;

for k=1:floor(nmarkets/2)
    a=close(idx1:idx2,2*k-1)\close(idx1:idx2,2*k);
    
    spread=close(idx1:idx2,2*k-1)-a*close(idx1:idx2,2*k);
    
    spread_mean=mean(spread);
    spread_std=std(spread);
    spread_current=close(ndays,2*k-1)-a*close(ndays,2*k);
    
    if(spread_current>=spread_mean+himark*spread_std)
        positions(2*k-1)=-1;
    elseif(spread_current<=spread_mean+lomark*spread_std)
        positions(2*k-1)=1;
    elseif((spread_current<=spread_mean) && (positions_prev(2*k-1)==1))
        positions(2*k-1)=positions_prev(2*k-1);
    elseif((spread_current>=spread_mean) && (positions_prev(2*k-1)==-1))
        positions(2*k-1)=positions_prev(2*k-1);
    end
end
