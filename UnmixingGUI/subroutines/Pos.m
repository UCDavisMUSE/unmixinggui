function Pos(n, N)
figure;
s = get(0,'Screensize');
sx = s(3);
sy = s(4);
style = 'new';

switch style
    case 'new'
        set(gcf, 'OuterPosition', [(n-1)*sx/N, 0, sx/N, sy/2])    
    
    case 'old'
        if (n==1)
            set(gcf,'Position',[0 sy/2 sx/2 sy/2 - 75]);
        end
        if (n==3)
            set(gcf,'Position',[0 0 sx/2 sy/2-75]);
        end
        if (n==2)
            set(gcf,'Position',[sx/2 sy/2 sx/2 sy/2-75]);
        end
        if (n==4)
            set(gcf,'Position',[sx/2 0 sx/2 sy/2-75]);
        end

        if (n==5)
            set(gcf,'Position',[0 sy/2 sx/2 sy/2 - 75]);
            % if you have two screens use this one:
            % set(gcf,'Position',[sx sy/2 sx/2 sy/2 - 75]);
        end
        if (n==7)
            set(gcf,'Position',[0 0 sx/2 sy/2-75]);
            % set(gcf,'Position',[sx 0 sx/2 sy/2-75]);
        end
        if (n==6)
            set(gcf,'Position',[sx/2 sy/2 sx/2 sy/2-75]);
            % set(gcf,'Position',[sx+sx/2 sy/2 sx/2 sy/2-75]);
        end
        if (n==8)
            set(gcf,'Position',[sx/2 0 sx/2 sy/2-75]);
            % set(gcf,'Position',[sx+sx/2 0 sx/2 sy/2-75]);
        end

end