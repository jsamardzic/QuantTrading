function backtest(strategy)
aapl = csvread('AAPL.csv', 1,1);
n = length(aapl);
close = aapl(:, 4);
open = aapl(:, 1);
retrn=zeros(1,n);

balance=1000;
stocks=0;
bp=0;
bc=balance;

for i=1:(n-1)
    bp=bc;
    switch (strategy(close(1:i), 5, 10))
        case 1
            if(balance>0)
                stocks=balance/open(i+1);
                balance=0;
            end
        case -1
            if(stocks>0)
                balance=stocks*open(i+1);
                stocks=0;
            end
    end
    if(balance>0)
        bc=balance;
    end
    if(balance==0)
        bc=stocks*close(i+1);
    end
    retrn(i)=(bc-bp)/bp;
    fprintf("%d\t%d\t%f\t%f\t%f\n", i, trendfollowing(close(1:i), 5, 10), balance, stocks, retrn(i));
end
if(stocks~=0)
    balance=stocks*close(n);
    stocks=0;
end

[maxd, maxdd] = drawdowns(retrn);
fprintf("Balance: %f\n", balance);
fprintf("Sharpe ratio: %f\n", sharperatio(retrn));
fprintf("Max drawdown: %f\nMax drawdown duration: %d\n", maxd, maxdd);
end