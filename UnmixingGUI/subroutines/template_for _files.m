clc;
fid = fopen('exp.txt','w');
fprintf(fid,'%6.2f \n ',Time);
fclose(fid);