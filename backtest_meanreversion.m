tic;

m1=1:1:50;
m2=1:1:50;
nm1=numel(m1);
nm2=numel(m2);
sr=zeros(nm1,nm2);

parameters = struct();
parameters.markets={'KO', 'MCD', 'SBUX'};
risk_free_return=0.0;
slippage=0.05;
verbose=false;
days_range=[0,0.8];
for k1=1:nm1
    parameters.m1=m1(k1);
    for k2=1:nm2
        parameters.m2=m2(k2);
        if m1(k1)>=m2(k2)
            sr(k1,k2)=-realmax;
            continue;
        end
        
        [error, sr(k1,k2)]=backtest(@meanreversion, 'parameters', ...
            parameters, 'risk_free_return', risk_free_return, ...
            'slippage', slippage, 'verbose', verbose, 'days_range', ...
            days_range);
        if error
            sr(k1,k2)=-realmax;
        end
    end
end

srmax=max(sr(:));
[k1,k2]=ind2sub(size(sr), find(sr==srmax));
fprintf('Max Sharpe ratio = %f, for m1=%d and m2=%d\n', srmax, ...
    m1(k1(1)), m2(k2(1)));

toc;