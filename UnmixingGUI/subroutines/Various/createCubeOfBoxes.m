clc;
N = 30; % picture size
n = 10; % numberOfImages
box1 = makeb(30,10,10,10);
box2 = 2 * makeb(30,10,15,15);
mybox = box1 + box2;
imagesc(mybox);
colormap(gray);

x = zeros(30,30,10);
x(:,:,3) = box1;
x(:,:,6) = box2;
dot = [12,12;
       17,17;
       22,22];
profile = zeros(3,n);
for i = 1:3
    for j = 1:n
        profile(i,j) = x(dot(i,1),dot(i,2),j);
    end
end

for i = 1:n
    imagesc(x(:,:,i));
    colormap(gray);
    M(i) = getframe;
    close;
end
movie(M)

plot(t,profile);



