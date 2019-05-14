function [positions, parameters] = meanreversion(close,parameters,positions)
if ~isfield(parameters, 'markets')
    parameters.markets={'KO', 'MCD', 'SBUX'};
end
if ~isfield(parameters, 'm1')
    parameters.m1=11;
end
if ~isfield(parameters, 'm2')
    parameters.m2=29;
end

nmarkets = numel(parameters.markets);
sma_quot=zeros(nmarkets,1);
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
    
    sma_quot(k)=sma1/sma2;
end

sma_quot_min=min(sma_quot);
sma_quot_max=max(sma_quot);

for k=1:nmarkets
    if (sma_quot(k)==sma_quot_min)
        positions(k)=1;
    elseif (sma_quot(k)==sma_quot_max)
        positions(k)=-1;
    end
end
