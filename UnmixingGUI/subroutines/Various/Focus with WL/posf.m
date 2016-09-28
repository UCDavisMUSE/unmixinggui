function h = posf(n);
h = figure;
s = get(0,'Screensize');
sx = s(3);
sy = s(4);


if (n==1);
    set(gcf,'Position',[80 100 1820 1000]);
end

if (n==2);
    set(gcf,'Position',[sx + 80 200 sx-400 sy-300]);
end
