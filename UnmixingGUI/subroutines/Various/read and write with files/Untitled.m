% profile = [linspace(0,1,100); linspace(1,10,100)];
% fid = fopen('exp.txt','w');
% fprintf(fid,['%6.2f %' '\n'],profile);
% fclose(fid);
clc

fid = fopen('spectra.txt');
fid
a = fscanf(fid,'%g %g %g %g %g %g %')
fclose(fid);