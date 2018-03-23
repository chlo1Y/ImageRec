function [truePosRate,falsePosRate,accuracy,truePosRateList,falsePosRateList,truePos,falseNeg,trueNeg,falsePos] = HyperparameterTuning(xTrain, yTrain, xTest, yTest,net)

% Train and evaluate an SVM
YTestPred= predict(net, xTest);
truePosRateList = [];
falsePosRateList = [];
acc = 0;
Boundary = 0;
for decisionBoundary = -5:0.0001:5
    
    [truePosRate, falsePosRate, accuracy] = calcRate(YTestPred.distances(:,2), decisionBoundary, yTest,detectedClasses);
    if mod( decisionBoundary , 0.1 ) == 0
        truePosRateList(end+1) = truePosRate;
        falsePosRateList(end+1) = falsePosRate;
    end
%     disp(accuracy)
    if accuracy>acc
        acc = accuracy;
        Boundary = decisionBoundary;
    end
end
[truePosRate, falsePosRate, accuracy] = calcRate(YTestPred.distances(:,2), Boundary, yTest,detectedClasses);
% [truePos,falseNeg,trueNeg,falsePos] = diffFourVal(yVal,detectedClasses)
end

function [truePosRate, falsePosRate, accuracy] = calcRate(distance, decisionBoundary, yVal,detectedClasses)
    [truePos, falsePos,falseNeg, trueNeg] = fourVal(distance, decisionBoundary, yVal);
%     [truePos,falseNeg,trueNeg,falsePos] = diffFourVal(yVal,detectedClasses)
    truePosRate = truePos/(truePos+falseNeg);
    falsePosRate = falsePos/(falsePos+trueNeg);
    accuracy = (truePos+trueNeg)/length(yVal);
end

function [truePos, falsePos,falseNeg, trueNeg] = fourVal(distance, decisionBoundary, yVal)
    truePos = sum(distance>decisionBoundary & yVal=='sunset');
    falsePos = sum(distance>decisionBoundary & yVal=='nonsunset');
    falseNeg = sum(distance<=decisionBoundary & yVal=='sunset');
    trueNeg = sum(distance<=decisionBoundary & yVal=='nonsunset');
end

function [truePos,falseNeg,trueNeg,falsePos] = diffFourVal(yValidate,detectedClasses)
truePos=0;
trueNeg=0;
falsePos=0;
falseNeg=0;
for i = 1:length(yValidate)
%     fprintf('Point %d, True class: %s, detected class: %s, distance: %0.2f\n', i, yValidate(i), detectedClasses(i), distances(i,2))
    if(yValidate(i)=='roadSign' && detectedClasses(i)=='roadSign')
        truePos=truePos+1;
    end 
    if(yValidate(i)== 'roadSign' && detectedClasses(i)=='nonroadSign')
        falseNeg=falseNeg+1;
    end
    if(yValidate(i)=='nonroadSign' && detectedClasses(i)=='nonroadSign')
        trueNeg=trueNeg+1;
    end
    if(yValidate(i)=='nonroadSign' && detectedClasses(i)=='roadSign')
        falsePos=falsePos+1;
    end
end
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
contour(x11, x22, x1x2out, [-1 -1], 'b-');
contour(x11, x22, x1x2out, [0 0], 'k-');
contour(x11, x22, x1x2out, [1 1], 'g-');
end