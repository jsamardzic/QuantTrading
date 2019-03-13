function y = sharperatio(retrn,risk_free_return)
n=length(retrn);

retrntotal=prod(1+retrn);
retrntotal=retrntotal-1;
retrndaily=(1+retrntotal)^(1.0/n)-1;
retrnannually=(1+retrndaily)^252-1;
volaannually=sqrt(252)*std(retrn);
y=(retrnannually-risk_free_return)/volaannually;

end


