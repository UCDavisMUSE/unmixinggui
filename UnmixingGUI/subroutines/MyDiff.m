function dif = myDiff(image)
N = size(image);
dif1 = zeros(N);
dif2 = zeros(N);
dif1(2:N(1),:) = abs(diff(image,1,1));
dif2(:,2:N(2)) = abs(diff(image,1,2));
dif = double((dif1 + dif2) > 0);

dif = conv2(dif,[1 1 1 1],'same');

% 
% for i = 1:N(1)
%     for j = 1:N(2)
%         if dif(i,j) > 0 
%             dif(i-1,j) = 1;
%             dif(i+1,j) = 1;
%         end
%     end
% end