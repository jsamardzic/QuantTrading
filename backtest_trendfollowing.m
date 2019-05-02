tic;

m1=2:2:40;
m2=5:5:200;
nm1=numel(m1);
nm2=numel(m2);
sr=zeros(nm1,nm2);

parameters = struct();
parameters.markets={'AAPL','AMZN','FB'};
risk_free_return=0.0;
slippage=0.05;
verbose=false;
days_range=[0,0.8];
for k=1:nm1
    parameters.m1=m1(k);
    for l=1:nm2
        parameters.m2=m2(l);
        if m1(k)>=m2(l)
            sr(k,l)=-realmax;
            continue;
        end
        
        [error, sr(k,l)]=backtest(@trendfollowing, 'parameters', ...
            parameters, 'risk_free_return', risk_free_return, ...
            'slippage', slippage, 'verbose', verbose, 'days_range', ...
            days_range);
        if error
            sr(k,l)=-realmax;
        end
    end
end

srmax=max(sr(:));
[rows,cols]=find(sr==srmax);
fprintf('Max Sharpe ratio = %f, for m1=%d and m2=%d\n', srmax, ...
    m1(rows(1)), m2(cols(1)));

toc;