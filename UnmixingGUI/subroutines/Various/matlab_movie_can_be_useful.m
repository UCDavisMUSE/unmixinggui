  fig=figure;
       set(fig,'DoubleBuffer','on');
       set(gca,'xlim',[-80 80],'ylim',[-80 80],...
           'NextPlot','replace','Visible','off')
       mov = avifile('example.avi')
       x = -pi:.1:pi;
       radius = [0:length(x)];
       for i=1:length(x)
        h = patch(sin(x)*radius(i),cos(x)*radius(i),[abs(cos(x(i))) 0 0]);
        set(h,'EraseMode','xor');
        F = getframe(gca);
        mov = addframe(mov,F);
        
       end
       size(mov)
       mov = close(mov);