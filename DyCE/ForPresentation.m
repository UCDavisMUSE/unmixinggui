function h = ForPresentation(organList, myTitle)
% function ForPresentation(organList, myTitle)
%
% For presenting RCA components. Meant to be used with RCA.
%
% N.Bozinovic, 08/15/08

h = Posf(2);
N = size(organList,3);
    
for i = 1:min(N,8)
    subplot(2,4,i)
    imagesc(organList(:,:,i))
    axis off image
    colormap gray
    colorbar
end

annotation1 = annotation(...
    gcf,'textbox',...
    'Position',[0.4538 0.9389 0.1049 0.03611],...
    'FitHeightToText','off',...
    'LineStyle','none',...
    'String',{myTitle});

if N > 8
    Posf(2);
    for i = 9:N
        subplot(2,4,i-8)
        imagesc(organList(:,:,i))
        axis off image
        colormap gray
        colorbar
    end
    annotation1 = annotation(...
        gcf,'textbox',...
        'Position',[0.4538 0.9389 0.1049 0.03611],...
        'FitHeightToText','off',...
        'LineStyle','none',...
        'String',{[ 'con''d - ' myTitle]});
end
