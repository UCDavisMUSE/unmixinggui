clc;

fid = fopen('name populated X Y rect left right array','w');
for i = 1:9
    fprintf(fid,'%s\n',handles.organs(i).name);
end
fclose(fid);