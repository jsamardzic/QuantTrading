function [positions, parameters] = trendfollowing(close,parameters)
if ~isfield(parameters, 'markets')
    parameters.markets={'AAPL'};
end
if ~isfield(parameters, 'm1')
    parameters.m1=5;
end
if ~isfield(parameters, 'm2')
    parameters.m2=10;
end

ndays = size(close,1);
nmarkets = length(parameters.markets);
sma1=0.0;
sma2=0.0;

positions=zeros(nmarkets,1);

equity=1;
exposure=zeros(nmarkets,1);

m1 = parameters.m1;
m2 = parameters.m2;

if m1 > ndays
    m1=ndays;
end
if m2>ndays
    m2=ndays;
end

for k=1:nmarkets
    for l=(ndays-m1+1):ndays
        sma1=sma1+close(l,k);
    end
    sma1=sma1/m1;
    
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


