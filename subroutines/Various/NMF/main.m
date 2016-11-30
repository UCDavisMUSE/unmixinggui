clc;
close all;

% Main program.
%
% Problem: Factorize non-negative matrix V into two non-negative matricies W and H, so V = W*H;
% Solution: We use Lee, Seung proposed method (Nature 1999). Initial W and
% H are random, then updated as:
%
% W(i,a) = W(i,a)*sum( V(i,:)./WH(i,:).*H(a,:) )
% W(i,a) = W(i,a)/ sum( W(:,a));
% H(a,mu) = H(a,mu) sum( W(:,a).*V(:,mu)./WH(:,mu) );
% 
% to be continued ...


V  = [1 2 0; 1 2 0;0 0 6];
e = eig(V);
if sum(e<0) ~= 0 
    disp('change matrix');
    break
end

n = size(V,1);
m = size(V,2);
r = 3;
if ((n+m)*r < n*m) 
    disp('rank is too small');
    break
end


W = rand(3,3);
H = rand(3,3);
WH = W*H;
j = 0;
N = 800;
F = zeros(N,1);
tol = 1;
old = 0;
while ((j<N) & (tol > 100*eps))
    j = j+1;
    tempW = W;
    tempH = H;
    tempWH = W*H;
    F(j) = sum(sum([ V .* log(tempWH) - tempWH ]));
    %tol = F(j) - old;
    %old = F(j);
    
    for a = 1:size(H,1)
        for mu = 1:size(H,2)
            H(a,mu) = tempH(a,mu)*sum( tempW(:,a).*V(:,mu)./tempWH(:,mu) );
        end
    end
    
    for i = 1:size(W,1);
        for a = size(W,2);
            W(i,a) = tempW(i,a)*sum( V(i,:)./tempWH(i,:).*tempH(a,:) );
        end
    end
    for i = 1:size(W,1);
        for a = size(W,2);
            W(i,a) = W(i,a) / sum( W(:,a));    
        end
    end
    
    
  
    
%     disp(['j = ' num2str(j)]);
%     disp(['W = ']);
%     W;
%     disp(['H = ']);
%     H;
%     disp(['WH = ']);
%     WH;
%     disp(['F = ']);
    
end
%pos(4)
%plot(F);
%axis([0 20 -10 10])
tempWH
W
H
