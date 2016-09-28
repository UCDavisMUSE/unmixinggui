clc;
close all;
% load particle   % Get C, d
% lb = zeros(400,1);
% options = optimset('PrecondBandWidth',inf);
% [x,resnorm,residual,exitflag,output] = lsqlin(C,d,[],[],[],[],lb,[],[],options);

load sc50b
[x,fval,exitflag,output] = ...
    linprog(f,A,b,Aeq,beq,lb,[],[],optimset('Display','iter'))