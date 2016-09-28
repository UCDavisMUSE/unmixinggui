function NicePresentation(organDynamics,myTitleList,timeSampledArray,rawArrayList,derivArrayList)

M = size(organDynamics,3);
Posf(2);

for i = 1:min(4,M)
    j = i;
    oneImage(i,j,organDynamics,myTitleList,timeSampledArray,rawArrayList,derivArrayList)
end

if M > 4
    Posf(2);
    for i = 5:min(M,8);
        j = i-4;
        oneImage(i,j,organDynamics,myTitleList,timeSampledArray,rawArrayList,derivArrayList)
    end
end
if M > 8 
    Posf(2);
    for i = 9:min(M,12)
        j = i-8;
        oneImage(i,j,organDynamics,myTitleList,timeSampledArray,rawArrayList,derivArrayList)
    end
end
if M > 12 
    Posf(2);
    for i = 13:min(M,16)
        j = i-12;
        oneImage(i,j,organDynamics,myTitleList,timeSampledArray,rawArrayList,derivArrayList)
    end
end

% -------------------

function oneImage(i,j,organDynamics,myTitleList,timeSampledArray,rawArrayList,derivArrayList)

subplot(3,4,j);
PutImage(organDynamics(:,:,i),myTitleList(i,:));
subplot(3,4,4+j);
plot(rawArrayList);
line([timeSampledArray(1,i) timeSampledArray(1,i)],[0 max(rawArrayList)*1.1],'LineStyle','--');
line([timeSampledArray(2,i) timeSampledArray(2,i)],[0 max(rawArrayList)*1.1],'LineStyle','--');
subplot(3,4,8+j);
plot(derivArrayList);
line([timeSampledArray(1,i) timeSampledArray(1,i)],[0 max(derivArrayList)*1.1],'LineStyle','--');
line([timeSampledArray(2,i) timeSampledArray(2,i)],[0 max(derivArrayList)*1.1],'LineStyle','--');        
    