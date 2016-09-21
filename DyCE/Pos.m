function pos(n);
figure;
s = get(0,'Screensize');
sx = s(3);
sy = s(4);


if (n==1);
    set(gcf,'Position',[0 sy/2 sx/2 sy/2 - 75]);
end
if (n==2);
    set(gcf,'Position',[0 0 sx/2 sy/2-75]);
end
if (n==3);
    set(gcf,'Position',[sx/2 sy/2 sx/2 sy/2-75]);
end
if (n==4);
    set(gcf,'Position',[sx/2 0 sx/2 sy/2-75]);
end

if (n==5);
    set(gcf,'Position',[sx sy/2 sx/2 sy/2 - 75]);
end
if (n==6);
    set(gcf,'Position',[sx 0 sx/2 sy/2-75]);
end
if (n==7);
    set(gcf,'Position',[sx+sx/2 sy/2 sx/2 sy/2-75]);
end
if (n==8);
    set(gcf,'Position',[sx+sx/2 0 sx/2 sy/2-75]);
end
