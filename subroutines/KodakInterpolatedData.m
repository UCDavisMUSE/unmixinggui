% function KodakInterpolatedData
clc;

kodak = KodakData;

lambdaOriginal = kodak(:,1);
lambda = lambdaOriginal(1):lambdaOriginal(end);

kodakInterpolated = zeros(length(lambda),4);

kodakInterpolated(:,1) = lambda;
kodakInterpolated(:,2) = interp1(lambdaOriginal, kodak(:,2), lambda);
kodakInterpolated(:,3) = interp1(lambdaOriginal, kodak(:,3), lambda);
kodakInterpolated(:,4) = interp1(lambdaOriginal, kodak(:,4), lambda);

csvwrite('KodakSensorData.csv', kodakInterpolated)
disp('CSV file produced');