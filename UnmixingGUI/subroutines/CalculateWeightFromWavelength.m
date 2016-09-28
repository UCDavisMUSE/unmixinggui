function weight = CalculateWeightFromWavelength(wavelength, kodak, filterWidth)
% For a given wavelength and filterWidth, say 500nm and 20nm
% Integrates spectral responses from Kodak CCD sensor to give a RGB color
% weight in absolute units.


lambda = kodak(:,1);

if wavelength < 50
    wavelength = 400 + 20*wavelength; 
end

% if (wavelength - filterWidth/2 < lambda(1) )
     % msgbox('Wavelengths smaller then 250 nm are unsupported');
% end
% if (wavelength + filterWidth/2 > lambda(end))
%     msgbox('Wavelengths larger then then 1100 nm are unsupported');
% end

filter = (lambda >= wavelength - filterWidth/2) & (lambda <= wavelength + filterWidth/2);
weight = [sum(filter.*kodak(:,2)), sum(filter.*kodak(:,3)), sum(filter.*kodak(:,4))];
