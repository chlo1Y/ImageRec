% Example of using a datastore, see 
clc;

rootdir = '\Users\Administrator\Documents\CSSE463\Sunset Detector\images\';
subdir = [rootdir 'train'];


subdir1 = [rootdir 'validate'];

subdir2 = [rootdir 'test'];

net = alexnet;
inputSize = net.Layers(1).InputSize(1:2);

trainImages = imageDatastore(...
    subdir, ...
    'IncludeSubfolders',true, ...
    'LabelSource', 'foldernames');
trainImages.ReadFcn = @(loc)imresize(imread(loc),inputSize);
% 
vaImages = imageDatastore(...
    subdir1, ...
    'IncludeSubfolders',true, ...
    'LabelSource', 'foldernames');
vaImages.ReadFcn = @(loc)imresize(imread(loc),inputSize);

% testImages = imageDatastore(...
%     subdir2, ...
%     'IncludeSubfolders',true, ...
%     'LabelSource', 'foldernames');
% testImages.ReadFcn = @(loc)imresize(imread(loc),inputSize);
% Make datastores for the validation and testing sets similarly.

fprintf('Read images into datastores\n');
% 
% xTrain = imageDatastoreReader(trainImages);
% yTrain = trainImages.Labels;
% 
% xTest = imageDatastoreReader(testImages);
% yTest = testImages.Labels;
% 
% xValidate = imageDatastoreReader(vaImages);
% yValidate = vaImages.Labels;

%[tpr fpr]= mySVMtrain(xTrain,yTrain, xTest, yTest);


%% Train and evaluate an SVM
% kernelScale= 7; % hard test kernel scale 
% net = fitcsvm(xTrain, yTrain, 'KernelFunction', 'rbf', 'KernelScale', kernelScale, 'BoxConstraint', 120); 
% fprintf('\n\n\n\n');
%


%% validate 
% [detectedClasses, distances] = predict(net, xValidate);
% 
% truePos=0;
% trueNeg=0;
% falsePos=0;
% falseNeg=0;
% 
% 
% for i = 1:length(yValidate)
%     fprintf('Point %d, True class: %s, detected class: %s, distance: %0.2f\n', i, yValidate(i), detectedClasses(i), distances(i,2))
%     if(yValidate(i)=='sunset' && detectedClasses(i)=='sunset')
%         truePos=truePos+1;
%     end 
%     if(yValidate(i)== 'sunset' && detectedClasses(i)=='nonsunset')
%         falseNeg=falseNeg+1;
%     end
%     if(yValidate(i)=='nonsunset' && detectedClasses(i)=='nonsunset')
%         trueNeg=trueNeg+1;
%     end
%     if(yValidate(i)=='nonsunset' && detectedClasses(i)=='sunset')
%         falsePos=falsePos+1;
%     end
% end

%% test 
% kernelScale= 7; % hard test kernel scale 
% net = fitcsvm(xTrain, yTrain, 'KernelFunction', 'rbf', 'KernelScale', kernelScale, 'BoxConstraint', 90); 
% 
% fprintf('\n\n\n\n');
% 
% [detectedClasses, distances] = predict(net, xTest);
% 
% truePosTest=0;
% trueNegTest=0;
% falsePosTest=0;
% falseNegTest=0;
% 
% 
% for i = 1:length(yTest)
%     fprintf('Point %d, True class: %s, detected class: %s, distance: %0.2f\n', i, yTest(i), detectedClasses(i), distances(i,2))
%     if(yTest(i)=='sunset' && detectedClasses(i)=='sunset')
%         truePosTest=truePosTest+1;
%         fprintf('truePos %d\n', i);
%     end 
%     if(yTest(i)== 'sunset' && detectedClasses(i)=='nonsunset')
%         falseNegTest=falseNegTest+1;
%         fprintf('falseNeg %d\n', i);
%     end
%     if(yTest(i)=='nonsunset' && detectedClasses(i)=='nonsunset')
%         trueNegTest=trueNegTest+1;
%         fprintf('trueNeg %d\n', i);
%     end
%     if(yTest(i)=='nonsunset' && detectedClasses(i)=='sunset')
%         falsePosTest=falsePosTest+1;
%         fprintf('falsePos %d\n', i);
%     end
% end
% 
% 
% 
% 
%% CNN

numTrainImages = numel(trainImages.Labels);

%imds.ReadFcn = @(loc)imresize(trainImages(loc),inputSize);
% numClasses = numel(categories(trainImages.Labels));
% fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
layers = [imageInputLayer([227 227 3]);
          convolution2dLayer(10,20);
          reluLayer();
          maxPooling2dLayer(3,'Stride',3);
          convolution2dLayer(10,20);
          reluLayer();
          maxPooling2dLayer(3,'Stride',3);
         
          convolution2dLayer(10,20);
          reluLayer();
          maxPooling2dLayer(3,'Stride',3);
          fullyConnectedLayer(2);
          softmaxLayer();
          classificationLayer()];
      options = trainingOptions('sgdm','MiniBatchSize',60,'MaxEpochs',4,...
	'InitialLearnRate',0.0001);

convnet = trainNetwork(trainImages,layers,options);
YTest = classify(convnet,vaImages);
TTest = vaImages.Labels;
accuracy = sum(YTest == TTest)/numel(TTest)


act1 = activations(convnet,testDigitData,'softmax');
% score = softmax(act1);
% score = reshape(act1,2,235);

score = act1(:,1);

% Y1Test = classify(convnet,testImages);
% T1Test = testImages.Labels;
% accuracyTest = sum(Y1Test == T1Test)/numel(T1Test)


%%Alex Transfer
% numTrainImages = numel(trainImages.Labels);
% idx = randperm(numTrainImages,16);
% 
% layersTransfer = net.Layers(1:end-3);
% numClasses = numel(categories(trainImages.Labels))
% layers = [
%     layersTransfer
%     fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
%     softmaxLayer
%     classificationLayer];
% miniBatchSize = 10;
% numIterationsPerEpoch = floor(numel(trainImages.Labels)/miniBatchSize);
% options = trainingOptions('sgdm',...
%     'MiniBatchSize',miniBatchSize,...
%     'MaxEpochs',4,...
%     'InitialLearnRate',1e-4,...
%     'Verbose',false,...
%     'Plots','training-progress',...
%     'ValidationData',vaImages,...
%     'ValidationFrequency',numIterationsPerEpoch);
% netTransfer = trainNetwork(trainImages,layers,options);
% predictedLabels = classify(netTransfer,vaImages);
% 
% idx = [1 5 10 15];
% figure
% for i = 1:numel(idx)
%     subplot(2,2,i)
%     I = readimage(vaImages,idx(i));
%     label = predictedLabels(idx(i));
%     imshow(I)
%     title(char(label))
% end
% 
% valLabels = vaImages.Labels;
% accuracy = mean(predictedLabels == valLabels)


%% CNN2
% layers = [imageInputLayer([28 28 1]);
%           convolution2dLayer(5,20);
%           reluLayer();
%           maxPooling2dLayer(2,'Stride',2);
%           fullyConnectedLayer(10);
%           softmaxLayer();
%           classificationLayer()];
% options = trainingOptions('sgdm','MaxEpochs',20,...
% 	'InitialLearnRate',0.0001);
% convnet = trainNetwork(trainImages,layers,options);
% YTest = classify(convnet,testImages);
% TTest = testDigitData.Labels;
% accuracy = sum(YTest == TTest)/numel(TTest)
% 
% 
