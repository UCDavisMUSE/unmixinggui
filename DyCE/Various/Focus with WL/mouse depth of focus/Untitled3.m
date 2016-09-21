clc;
A = ones(500,300);

[N1,N2] = size(A);
[M1,M2] = size(hair_m);

if (N1<M1)||(N2<M2) 
    disp('wrong')
    break
    
end
tic
C = zeros(N1-M1,N2-M2);
for i = 1:N1-M1
   for j = 1:N2-M2
       temp = A(i:i+M1-1,j:j+M2-1);
       C(i,j) = sum(temp(:).*hair_m(:));
   end
end
disp('done')
toc
   
    
