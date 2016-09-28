function banana = BananaFunction(x,const)
%x
if length(x) == 1
    x(2) = 1;
end
%x
banana = 100*(x(2)-x(1)^2)^2+(1-x(1))^2 + const;