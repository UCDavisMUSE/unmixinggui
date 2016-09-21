function newHandles = clearOrgans(handles)
N = handles.N;
for i = 1:9
    handles.organs(i).array = zeros(1,N(3));
    handles.organs(i).derivarray = zeros(1,N(3));
    handles.organs(i).deriv2array = zeros(1,N(3));
    handles.organs(i).concatarray = zeros(1,N(3));
    handles.organs(i).rect = [1 1 N(2) N(1)];
    handles.organs(i).X = 1;
    handles.organs(i).Y = 1;
    handles.organs(i).leftFrame = 1;
    handles.organs(i).rightFrame = N(3);
    handles.organs(i).populated = 0;
    handles.organs(i).timeSampled = 1:N(3); 
end
newHandles = handles;