function wavelength = GetWavelengthFromName(name)
dotIndex = strfind(name,'.tif');
i = dotIndex-1;
while (~isempty(str2num(name(i))))
    i = i-1;
end
wavelength = str2double(name((i+1):(dotIndex-1)));

    