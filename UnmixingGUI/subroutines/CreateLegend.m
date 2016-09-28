% make Legend from names
function legendNew = CreateLegend(handles)
legendNew = cell(1, handles.maxNumberOfSpectra);
j = 0;
for i = 1:handles.maxNumberOfSpectra
    if handles.spectra(i).show
        j = j + 1;
        legendNew{j} = handles.spectra(i).name;
    end
end
legendNew = RemoveTrailingPositionsInCell(legendNew);
