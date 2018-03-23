lowerTbound=-5;
upperTbound= 5;
Tstep = 0.01;
plotHeight = ((upperTbound - lowerTbound)/Tstep+1);
toPlot = zeros([uint8(plotHeight),3]);
%%generate ROC data
counter = 1;
predictedTestLabels = classify(net,validImages,'MiniBatchSize', 10);
layer = 'fc';
testFeatures = activations(net,testImages,layer,'MiniBatchSize', 10,'ExecutionEnvironment','gpu');
distances = testFeatures(:,:,2,:);

for q = lowerTbound:Tstep:upperTbound
    [toPlot(counter,1), toPlot(counter,2),toPlot(counter,3)] = thresholdFeedback(predictedTestLabels,distances,q,testImages.Labels);
    counter = counter + 1;
end

truePosRate = toPlot(:,1);
falsePosRate = toPlot(:,2);
thresholValue = toPlot(:,3);
% Create a new figure. You can also number it: figure(1)
figure;
% Hold on means all subsequent plot data will be overlaid on a single plot
hold on;
% Plots using a blue line (see 'help plot' for shape and color codes 
plot3(falsePosRate, truePosRate,thresholValue, 'b-', 'LineWidth', 2);
% Overlaid with circles at the data points
plot3(falsePosRate, truePosRate,thresholValue, 'bo', 'MarkerSize', 1, 'LineWidth', 2);

% You could repeat here with a different color/style if you made 
% an enhancement and wanted to show that it outperformed the baseline.

% Title, labels, range for axes
title('Receiver Operating Characteristic Plot', 'fontSize', 15); % Really. Change this title.
xlabel('False Positive Rate', 'fontWeight', 'bold');
ylabel('True Positive Rate', 'fontWeight', 'bold');
zlabel('Threshold', 'fontWeight', 'bold');
% TPR and FPR range from 0 to 1. You can change these if you want to zoom in on part of the graph.
axis([min(toPlot(:,2)) max(toPlot(:,2)) min(toPlot(:,1)) max(toPlot(:,1))]);

%%get FPR, TPR and accuracy 
function [FPR, TPR] = getResult(detectedClasses, yValid)
truepositive = 0;
falsenegative = 0;
falsepositive = 0;
truenegative = 0;

for i = 1:length(yValid)
    %%fprintf('Point %d, True class: %d, detected class: %d, distance: %0.2f\n', i, yTrain(i), detectedClasses(i), distances(i,2))
    if (yValid(i) == detectedClasses(i)) && (yValid(i) == 'roadsign')
        truepositive = truepositive +1;
    elseif (yValid(i) == detectedClasses(i)) && (yValid(i) == 'nonroadsign')
        truenegative = truenegative + 1;
    elseif (yValid(i) ~= detectedClasses(i)) && (yValid(i) == 'roadsign')
        falsenegative = falsenegative + 1;
    else
        falsepositive = falsepositive + 1;
    end     
end

TPR = truepositive / (truepositive + falsenegative);
FPR = falsepositive / (falsepositive + truenegative);
end

%%calculate TPR and FPR with a given threshold
function [TPR, FPR, threshold] = thresholdFeedback(detectedClasses,distances,threshold,yTest)
    for i = 1:length(yTest)
        if distances(i) < threshold
            detectedClasses(i) = 'nonroadsign';
        else
            detectedClasses(i) = 'roadsign';
        end        
    end
    [FPR, TPR] = getResult(detectedClasses, yTest);  
end