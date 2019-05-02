function [positions, parameters] = trendfollowing(close,parameters)
if ~isfield(parameters, 'markets')
    parameters.markets={'AAPL', 'AMZN', 'FB'};
end
if ~isfield(parameters, 'm1')
    parameters.m1=28;
end
if ~isfield(parameters, 'm2')
    parameters.m2=200;
end

nmarkets = numel(parameters.markets);
positions=zeros(nmarkets,1);

if isempty(close)
    return;
end

ndays = size(close,1);

m1 = parameters.m1;
m2 = parameters.m2;

if m1 > ndays
    m1=ndays;
end
if m2>ndays
    m2=ndays;
end

for k=1:nmarkets
    sma1=0.0;
    for l=(ndays-m1+1):ndays
        sma1=sma1+close(l,k);
    end
    sma1=sma1/m1;
    
    sma2=0.0;
    for l=(ndays-m2+1):ndays
        sma2=sma2+close(l,k);
    end
    sma2=sma2/m2;
    
    if (sma1 > sma2)
        positions(k)=1;
    elseif (sma1 < sma2)
        positions(k)=-1;
    end
end


