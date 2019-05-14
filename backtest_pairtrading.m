tic;

m=2:2:50;
lomark=linspace(-0.2,-2,10);
himark=linspace(0.2,2,10);
nm=numel(m);
nlomark=numel(lomark);
nhimark=numel(himark);
sr=zeros(nm,nlomark,nhimark);

parameters = struct();
parameters.markets = {'GM', 'F', 'JNJ', 'PG'};
risk_free_return=0.0;
slippage=0.05;
verbose=false;
days_range=[0,0.8];
for k1=1:nm
    parameters.m=m(k1);
    for k2=1:nlomark
        parameters.lomark=lomark(k2);
        for k3=1:nhimark
            parameters.himark=himark(k3);
            
            [error, sr(k1,k2,k3)]=backtest(@pairtrading, 'parameters', ...
                parameters, 'risk_free_return', risk_free_return, ...
                'slippage', slippage, 'verbose', verbose, 'days_range', ...
                days_range);
            if error
                sr(k1,k2,k3)=-realmax;
            end
        end
    end
end

srmax=max(sr(:));
[k1,k2,k3]=ind2sub(size(sr), find(sr==srmax));
fprintf('Max Sharpe ratio = %f, for m=%d lomark=%g and himark=%g\n', ...
    srmax, m(k1(1)), lomark(k2(1)), himark(k3(1)));

toc;