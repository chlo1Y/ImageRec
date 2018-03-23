function [truePosRateList,falsePosRateList,acc,Boundary] = CNNplotROC(distances,XVal,YVal)
    truePosRateList = [];
    falsePosRateList = [];
    Boundary = 0;
    acc = 0;
    for decisionBoundary = exp(-1000:1:0)
        [truePosRate, falsePosRate, accuracy] = calcRate(distances, decisionBoundary, YVal);
        truePosRateList(end+1) = truePosRate;
        falsePosRateList(end+1) = falsePosRate;
        if accuracy>acc
            acc = accuracy;
            Boundary = decisionBoundary;
        end
    end
   end

function [truePosRate, falsePosRate, accuracy] = calcRate(distance, decisionBoundary, yVal)
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



