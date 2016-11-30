function [outdata]=chebsmcube(data)
% CHEBSM Chebyschev smoothing along the spectral dimension of an 
% image cube.
% Syntax: [outdata]=chebsmcube(data);

outdata = zeros(size(data));

outdata(:,:,1)=(69*data(:,:,1)+4*data(:,:,2) ...
    -6*data(:,:,3)+4*data(:,:,4)-data(:,:,5))/70;

outdata(:,:,2)=(2*data(:,:,1)+27*data(:,:,2) ...
    +12*data(:,:,3)-8*data(:,:,4)+2*data(:,:,5))/35;

outdata(:,:,3:size(data,3)-2)= ...
    (-3*data(:,:,1:end-4)+12*data(:,:,2:end-3)+17*data(:,:,3:end-2) ...
    +12*data(:,:,4:end-1)-3*data(:,:,5:end))/35;

outdata(:,:,size(data,3)-1)=(2*data(:,:,end-4)-8*data(:,:,end-3) ...
    +12*data(:,:,end-2)+27*data(:,:,end-1)+2*data(:,:,end))/35;

outdata(:,:,size(data,3))=(-1*data(:,:,end-4)+4*data(:,:,end-3) ...
    -6*data(:,:,end-2)+4*data(:,:,end-1)+69*data(:,:,end))/70;
   

