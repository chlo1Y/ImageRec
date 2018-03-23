function features = imageDatastoreReader(datastore)
% Example of using an image datastore.

nBlocks = 7; % 
nImages = numel(datastore.Files);

features = zeros(nImages, nBlocks * nBlocks * 6); 
row = 1;
temp=[];
for i = 1:nImages
    [img, fileinfo] = readimage(datastore, i);
    % fileinfo struct with filename and another field.
    fprintf('Processing %s\n', fileinfo.Filename);
    % TODO: Write and call a feature extraction here to operate on image.
    % Hint: debug this code ELSEWHERE on 1-2 images BEFORE looping over lots of them...
    featureVector = featureExtract(img, nBlocks);
    features(row,:) = featureVector;
    row = row + 1;
%     if (i==997)
%         f1=figure;
%         title('truePos');
%         imshow(img)
%     end 
    if (i==971)
       fprintf('fileinfo %s', fileinfo.Filename);
       
    end 
%     if (i==62)
%         f3=figure;
%         title('flasePos');
%         imshow(img)
%     end 
%     if (i==63)
%         f4=figure;
%         title('trueNeg');
%         imshow(img)
%     end 
    
end
%%save('features.mat');


