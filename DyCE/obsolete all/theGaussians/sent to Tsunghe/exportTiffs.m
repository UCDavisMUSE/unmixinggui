function exportTiffs(x);
% function exportTiffs(x);
% Export tiffs from 3D matrix x in a folder '\tiff' (program creats one if neceseary)
disp('Begin export ...');
if (exist('tiff','dir') == 0) 
    mkdir('tiff');
else
    button = questdlg('Do you want to to change the name (default is ''raw'')?     .');
    if strcmp(button,'Yes')
        msgbox('Enter the new name in the matlab command window.             .','modal');
        name = input('Enter name and press enter: ','s');
    elseif  strcmp(button,'No')
        button1 = questdlg('Do you want to overwrite data?  .');
        if strcmp(button1,'Yes')
            name = 'raw';
        else
            disp('Export was canceled.'); 
            return;
        end
    else
        disp('Export was canceled.'); 
        return;
    end
end

map = colormap(gray(256));
for i = 1:size(x,3)
    imwrite(255*x(:,:,i)./max(x(:)),map,['tiff\' name '_' num2str(i,'%03g') '.tif']);
end
disp('export ended.');