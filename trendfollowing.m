function y = trendfollowing(close,m1,m2)
n = length(close);
sma1=0.0;
sma2=0.0;
if m1 > n
    m1=n;
end
if m2>n
    m2=n;
end

for i=(n-m1+1):n
    sma1=sma1+close(i);
end
sma1=sma1/m1;


for i=(n-m2+1):n
    sma2=sma2+close(i);
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


