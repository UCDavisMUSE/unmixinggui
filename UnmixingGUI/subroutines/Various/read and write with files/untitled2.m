clc;
fid1 = uigetfile('.txt')
fid = fopen(fid1);
g = fgets(fid);
a = fscanf(fid,'%g',[11 inf]); % It has two rows now.
a = a';
for i = 1:9
    blob(i).profile = a(:,i+1);
end
fclose(fid);