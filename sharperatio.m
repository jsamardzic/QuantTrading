function y = sharperatio(returns,risk_free_return)
n=length(returns);

return_total=prod(1+returns);
return_total=return_total-1;
return_daily=(1+return_total)^(1.0/n)-1;
return_annually=(1+return_daily)^252-1;
vola_annually=sqrt(252)*std(returns);
y=(return_annually-risk_free_return)/vola_annually;

end


