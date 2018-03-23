function [tpr, fpr]= mySVMtrain(xTrain, yTrain, xValidate, yValidate)
    tprTemp =0;
    fprTemp =100;;
    accuracyTemp=0;
    
    
    for kernelScale=2:5:50
        for BoxConstraint=50:50:1000
            numberOfSupportvector=0;
            truePos=0;
            trueNeg=0;
            falsePos=0;
            falseNeg=0;
            accuracy=0;
            net = fitcsvm(xTrain, yTrain, 'Standardize',true,'KernelFunction', 'rbf', 'KernelScale', kernelScale, 'BoxConstraint', BoxConstraint); 
            for g= 1: length(net.IsSupportVector)
                if  net.IsSupportVector(g)==1
                    numberOfSupportvector= numberOfSupportvector +1;
                end
            end 
            
            fprintf('%d \n', numberOfSupportvector);
            [detectedClasses, distances] = predict(net, xValidate);
            
            for i = 1:length(yValidate)
                if(yValidate(i)=='sunset' && detectedClasses(i)=='sunset')
                    truePos=truePos+1;
                end 
                if(yValidate(i)== 'sunset' && detectedClasses(i)=='nonsunset')
                    falseNeg=falseNeg+1;
                end
                if(yValidate(i)=='nonsunset' && detectedClasses(i)=='nonsunset')
                     trueNeg=trueNeg+1;
                end
                if(yValidate(i)=='nonsunset' && detectedClasses(i)=='sunset')
                    falsePos=falsePos+1;
                end
            end
            
            tpr= truePos/ (truePos +falseNeg);
            fpr =falsePos /(trueNeg+falsePos);
            accuracy = (truePos+trueNeg)/ (truePos+trueNeg+falsePos+falseNeg);
            if(accuracy > accuracyTemp)
                accuracyTemp= accuracy
                fprintf('accuracy %0.2f, kernek %d, boxCon %d \n', accuracyTemp, kernelScale, BoxConstraint);
            end 
            if(tpr > tprTemp)
                tprTemp = tpr;
            end 
            if (fpr <fprTemp)
                fprTemp=fpr;
            end 
            fprintf('KernelScale %d, BoxConstraint: %d, accuracy: %0.2f, truePosRate: %0.2f, falsePosrate: %0.2f\n', kernelScale, BoxConstraint,accuracy, tpr, fpr)
            fprintf('falsePos: %d\n', falsePos);

        end
    end 
    

end 



% 
