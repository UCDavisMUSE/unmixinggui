clc;
close all

fid = fopen('data2d.txt', 'r');
temp = zeros(1000,1000);
maxi = 1;
maxy = 1;
while ~feof(fid);
    tline = fgets(fid);
    p1 = strfind(tline,'[');
    p2 = strfind(tline,',');
    p3 = strfind(tline,']');
    p4 = strfind(tline,'f');
    
    i = uint16(str2num(tline(p1+1:p2-1)))+1;
    j = uint16(str2num(tline(p2+1:p3-1)))+1;
    temp(i,j) = double(str2num(tline(p3+1:p4-1)));  
    if i > maxi  maxi = i; end
    if j > maxi  maxj = j; end
end
fclose(fid);
xx = temp(1:maxi,1:maxj);
imagesc(xx);
colormap(gray);