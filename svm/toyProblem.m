% toyProblem.m
% Written by Matthew Boutell, 2006, updated 2017.
% Feel free to distribute at will.

clear all;

% We fix the seeds so the data sets are reproducible
seedTrain = 137;
seedTest = 138;
% This tougher data set is commented out.
[xTrain, yTrain] = GenerateGaussianDataSet(seedTrain);
title('hard training set');
[xTest, yTest] = GenerateGaussianDataSet(seedTest);
title('hard testing set');
% This one isn't too bad at all
% [xTrain, yTrain] = GenerateClusteredDataSet(seedTrain, 'Training set');
% [xTest, yTest] = GenerateClusteredDataSet(seedTest, 'Test set');


% Add your code here.
% KNOWN ISSUE: the linear decision boundary doesn't work 
% for this data set at all. Don't know why...
%kernelScale = 7; %simple Test kernel scale 
kernelScale= 3; % hard test kernel scale 
x1ran = [0 20];
x2ran = [0 20];

net = fitcsvm(xTrain, yTrain, 'KernelFunction', 'rbf', 'KernelScale', kernelScale, 'BoxConstraint', 40); 
f1 = figure;
plotboundary(net, x1ran, x2ran);
plotdata(xTrain, yTrain, x1ran, x2ran);
plotsv(net, xTrain, yTrain);

title(sprintf('Training Set Result/ Coutour plot'));
fprintf('Figure %i shows the decision boundary obtained from a SVM\n', ...
	f1.Number);
fprintf('with radial basis function kernel, kernel width %.1f.\n', kernelScale);
disp('This gives a decision boundary similar to the one shown in');

fprintf('\n\n\n\n');


%test set 
f2= figure;
plotboundary(net, x1ran, x2ran);
plotdata(xTest, yTest, x1ran, x2ran);
plotsv(net, xTest, yTest);


title(sprintf('Test Set result')); 
fprintf('Figure %i shows the decision boundary obtained from a SVM\n', ...
	f2.Number);
fprintf('with radial basis function kernel, kernel width %.1f.\n', kernelScale);
disp('This gives a decision boundary similar to the one shown in');

fprintf('\n\n\n\n');

[detectedClasses, distances] = predict(net, xTest);

truePos=0;
trueNeg=0;
falsePos=0;
falseNeg=0;
for i = 1:length(yTest)
    fprintf('Point %d, True class: %d, detected class: %d, distance: %0.2f\n', i, yTest(i), detectedClasses(i), distances(i,2))
    if(yTest(i)==1 && detectedClasses(i)==1)
        truePos=truePos+1;
    end 
    if(yTest(i)==1 && detectedClasses(i)==-1)
        falseNeg=falseNeg+1;
    end
    if(yTest(i)==-1 && detectedClasses(i)==-1)
        trueNeg=trueNeg+1;
    end
    if(yTest(i)==-1 && detectedClasses(i)==1)
        falsePos=falsePos+1;
    end
end



% Run this on a trained network to see the resulting boundary 
% (as in the demo)
% f3=figure;
% plotboundary(net, [0,20], [0,20]);

function plotdata(X, Y, x1ran, x2ran)
% PLOTDATA - Plot 2D data set

hold on;
ind = find(Y>0);
plot(X(ind,1), X(ind,2), 'ks');
ind = find(Y<0);
plot(X(ind,1), X(ind,2), 'kx');
text(X(:,1)+.2,X(:,2), int2str([1:length(Y)]'));
axis([x1ran x2ran]);
axis xy;
end

function plotsv(net, X, Y)
% PLOTSV - Plot Support Vectors
% 
hold on;
% Plot the support vectors.
posSV = net.SupportVectors(find(net.SupportVectorLabels > 0), :);
plot(posSV(:,1),posSV(:,2), 'rs');
negSV = net.SupportVectors(find(net.SupportVectorLabels < 0), :);
plot(negSV(:,1),negSV(:,2), 'rx');
end

function [x11, x22, x1x2out] = plotboundary(net, x1ran, x2ran)
% PLOTBOUNDARY - Plot SVM decision boundary on range X1RAN and X2RAN
% 

hold on;
nbpoints = 100;
x1 = x1ran(1):(x1ran(2)-x1ran(1))/nbpoints:x1ran(2);
x2 = x2ran(1):(x2ran(2)-x2ran(1))/nbpoints:x2ran(2);
[x11, x22] = meshgrid(x1, x2);
[dummy, x1x2out] = predict(net, [x11(:),x22(:)]);
x1x2out = x1x2out(:,2);
x1x2out = reshape(x1x2out, [length(x1) length(x2)]);
contour(x11, x22, x1x2out, [-0.99 -0.99], 'b-');
contour(x11, x22, x1x2out, [0 0], 'k-');
contour(x11, x22, x1x2out, [0.99 0.99], 'g-');
end


