clc;
rootdir = '\Users\Administrator\Documents\CSSE463\project\';
subdir = [rootdir 'projectImages\roadSign'];

imageSet = imageDatastore(...
    subdir, ...
    'ReadFcn', @rescale,...
    'IncludeSubfolders',true, ...
    'LabelSource', 'foldernames');

numTrainImages = numel(imageSet.Files);

for i=1:numTrainImages
    [img, fileinfo] = readimage(imageSet, i);
    img=img(:,[end:-1:1],:);
    imshow(img);
    
    baseFileName = sprintf('Doubled %d split.jpg', i);
    writeDir = 'C:\Users\Administrator\Documents\CSSE463\project\DoubledTrue';
    fullFileName = fullfile(writeDir, baseFileName);
    imwrite(img, fullFileName);
end 
   

function img =rescale(file)
    img = imread(file);
    img = imresize(img, [277,277]);
end 