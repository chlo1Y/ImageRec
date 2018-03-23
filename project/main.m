

rootdir = '\Users\Administrator\Documents\CSSE463\project\';
subdir = [rootdir 'testStatics'];

imageSet = imageDatastore(...
    subdir, ...
    'ReadFcn', @rescale,...
    'IncludeSubfolders',true, ...
    'LabelSource', 'foldernames');
%imageSet.ReadFcn = @(loc)imresize(imread(loc),inputSize);


imageSize= [277 277 1];

% rng(1) % For reproducibility
% [trainDigitData,testDigitData] = splitEachLabel(imageSet,...
% 				0.7,'randomize');

%  imageAug = imageDataAugmenter('RandXReflection', true);
%  datasource= augmentedImageSource(imageSize, xTrain,yTrain...
%      ,'DataAugmentation',imageAug);
% numTrainImages = numel(trainDigitData.Labels);
% 
% numTestingImages=numel(testDigitData.Labels);

% layers = [imageInputLayer([277 277 3]);
%           convolution2dLayer(3,10, 'Padding', 1);
%           batchNormalizationLayer();
%           reluLayer();
%           %maxPooling2dLayer(2,'Stride',2);
%           averagePooling2dLayer(2,'Stride',2);
%           
%           convolution2dLayer(3,10, 'Padding', 1);
%           reluLayer();
%           batchNormalizationLayer();
%           %maxPooling2dLayer(2,'Stride',2);
%           averagePooling2dLayer(2,'Stride',2);
%           
%           convolution2dLayer(3,20, 'Padding', 1);
%           reluLayer();
%           batchNormalizationLayer();
%           %maxPooling2dLayer(2,'Stride',2);
%           averagePooling2dLayer(2,'Stride',2);
%          
%           convolution2dLayer(3,10, 'Padding', 1);
%           reluLayer();
%           batchNormalizationLayer();
%           %maxPooling2dLayer(2,'Stride',2);
%           averagePooling2dLayer(2,'Stride',2);
%           
%           convolution2dLayer(5,10, 'Padding', 1);
%           reluLayer();
%           batchNormalizationLayer();
%           %maxPooling2dLayer(2,'Stride',2);
%           averagePooling2dLayer(2,'Stride',2);
% %           convolution2dLayer(10,20);
% %           reluLayer();
% %           maxPooling2dLayer(3,'Stride',3);
%           fullyConnectedLayer(2);
%           softmaxLayer();
%           classificationLayer()];
    
      %validationfreq= floor(size(trainDigitData,2)/miniBatchSize/2);
%        options = trainingOptions('sgdm','MiniBatchSize',64,'MaxEpochs',4,...
%  	'ValidationPatience',Inf, 'InitialLearnRate',0.0001, 'Plots','training-progress');
%'ValidationData',{valImages,valLabels},... 'ValidationFrequency',30,... 
% don't have validation data set due to insuffient memory on labtop. Need
% to add this line 


% convnet = trainNetwork(trainDigitData,layers,options);
% convnet.Layers

% [xTest,yTest]= digitTest4DArrayData;
%  YTestPred = classify(convnet,xTest);
%  accuracy = sum(YTestPred == yTest)/numel(yTest)

% YTest = classify(convnet,testDigitData);
% TTest = testDigitData.Labels;
% accuracy = sum(YTest == TTest)/numel(TTest);

act1 = activations(convnet,imageSet,'softmax');
% score = softmax(act1);
% score = reshape(act1,2,235);

score = act1(:,1)




% xTrain = imageDatastoreReader(trainDigitData);
% yTrain = trainDigitData.Labels;
% % 
%  xTest = imageDatastoreReader(testDigitData);
%  yTest = testDigitData.Labels;
%CNN stuff 
% [truePosRate, falsePosRate, accuracy, tpr, fpr]=HyperparameterTuning(trainDigitData, YTest,testDigitData, TTest,convnet);
% roc(tpr, fpr);

function img =rescale(file)
    img = imread(file);
    img = imresize(img, [277,277]);
end 
