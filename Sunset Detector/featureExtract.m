function features = featureExtract(img, nBlocks)

R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));

L = R + G + B;
S = R - B;
T = R - (G*2) + B;

row = size(img, 1);
col = size(img, 2);

height = floor(row / nBlocks);
width = floor(col / nBlocks);

lastHeight = row - 6*height;
lastWidth = col - 6*width;

splittedL = mat2cell(L, [height,height,height,height,height,height,lastHeight], ...
            [width, width,width, width,width, width,lastWidth]);
splittedS = mat2cell(S, [height,height,height,height,height,height,lastHeight], ...
            [width, width,width, width,width, width,lastWidth]);
splittedT = mat2cell(T, [height,height,height,height,height,height,lastHeight], ...
            [width, width,width, width,width, width,lastWidth]);

        
%features = zeros(nBlocks, nBlocks, 6);
features =[];
    
for i  = 1:7
    for j = 1:7
    tempLBlock = splittedL{i, j};
    singleLRowBlock = reshape(tempLBlock, [1 size(tempLBlock,1)*size(tempLBlock,2)]);
    Lstd = std(singleLRowBlock);
    Lmean = mean(singleLRowBlock);
    
    tempSBlock = splittedS{i, j};
    singleSRowBlock = reshape(tempSBlock, [1 size(tempSBlock,1)*size(tempSBlock,2)]);
    Sstd = std(singleSRowBlock);
    Smean = mean(singleSRowBlock);
    
    tempTBlock = splittedT{i, j};
    singleTRowBlock = reshape(tempTBlock, [1 size(tempTBlock,1)*size(tempTBlock,2)]);
    Tstd = std(singleTRowBlock);
    Tmean = mean(singleTRowBlock);
    
    features = [features Lmean Lstd Smean Sstd Tmean Tstd]; 
    %features =fitcsvm(features,'autoscale','rbf' );
    % features = autoscale(features,1);
    end
end

