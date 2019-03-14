function [maxd,maxdd] = drawdowns(returns)
n = length(returns);
d=0;
dd=0;
maxd=0;
maxdd=0;
current=1;
peak=current;
for i=1:n
    current=current*(returns(i)+1);
    if current>=peak
        peak=current;
        d=0;
        dd=0;
    end
    if current<peak
        d=peak-current;
        dd=dd+1;
        if d/peak>maxd
            maxd=d/peak;
        end
        if dd>maxdd
            maxdd=dd;
        end
    end
end
end

