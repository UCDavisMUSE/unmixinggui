%profile = handles.profile;

profileMax = max(profile);
profileMin = min(profile);

% finds the regions of high and low profile
bin = profile > profileMin + ( profileMax - profileMin )/10 ;

%finds the first and last index of a high region
n1 = find(bin,1,'first');
n2 = find(bin,1,'last');
stem(profile);
line([n1 n1],[0 profileMax])
line([n2 n2],[0 profileMax])
