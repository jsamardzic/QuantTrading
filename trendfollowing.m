function [y, parameters] = trendfollowing(close,parameters)
if ~isfield(parameters, 'markets')
    parameters.markets={'AAPL'};
end
if ~isfield(parameters, 'm1')
    parameters.m1=5;
end
if ~isfield(parameters, 'm2')
    parameters.m2=10;
end

n = size(close,1);
sma1=0.0;
sma2=0.0;

m1 = parameters.m1;
m2 = parameters.m2;

if m1 > n
    m1=n;
end
if m2>n
    m2=n;
end

for k=(n-m1+1):n
    sma1=sma1+close(k,1);
end
sma1=sma1/m1;


for k=(n-m2+1):n
    sma2=sma2+close(k,1);
end
sma2=sma2/m2;

if (sma1 > sma2)
    y=1;
else
    if (sma1 < sma2)
        y=-1;
    else
        y=0;
    end
end


