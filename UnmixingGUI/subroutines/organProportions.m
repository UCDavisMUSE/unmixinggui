%a  = organList(:,:,2);
%puti(a,'',1)
% ventral proportions
rect.lungs = [29  150  171  115];
rect.brain = [65    1  125  118];
rect.liver = [12  207  200  137];
rect.glands = [69  105  107   56];
rect.legvenas = [7  413  221   64];
rect.stomach = [10  306  204  115];

N = [478 255];
%rect = getrect(gcf)
%N = size(a);
yc = round(rect(1)+rect(3)/2);
xc = round(rect(2)+rect(4)/2);
width = rect(3);
height = rect(4);
proportions = [xc/N(1) yc/N(2) height/N(1) width/N(2)]
