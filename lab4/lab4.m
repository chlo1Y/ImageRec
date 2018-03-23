clear all;
img = imread('shapes.png');
%imshow(img)
[imageLabel, shapeNum]= bwlabel(img);
cc= bwconncomp(img);
i=12;%adjustable 
    
mask=ones(size(img,1), size(img,2));
mask(find(imageLabel==i))=0;
mask=~mask;
%imtool(mask);
area=bwarea(mask);


 %spatial covariance 
[r,c]=find(mask==1);
cMean=mean(c); %column mean
cNorm=c-cMean;
cNormSquared=(cNorm).^2;
sumSquared=sum(cNormSquared);
matrix(1,1)=sumSquared/area;
    
rMean=mean(r); %row mean 
rNorm=r-rMean;
rNormSquared=(rNorm).^2;
sumSauqredRow=sum(rNormSquared);
matrix(2,2)=sumSauqredRow/area;
    
xyNorm=rNorm.*cNorm;
sumxy=sum(xyNorm);
matrix(1,2)=sumxy/area;
matrix(2,1)=sumxy/area;

largestEigv=eigs(matrix,1);
smallestEigv=eigs(matrix,1,'smallestabs');
elongation=sqrt(largestEigv/smallestEigv); 
 
%circularity 
boundary = bwtraceboundary(mask, [r(1), c(1)], 'N');
boundR = boundary(:,1);
boundc = boundary(:,2);
boundR(end+1) = boundR(1);
boundc(end+1) = boundc(1);
pr = (boundR(2:end)-boundR(1:end-1));
pc = (boundc(2:end)-boundc(1:end-1));
distance = sqrt(pr.^2+pc.^2); 
perimeter = sum(distance);
circularity = (perimeter*perimeter)/area;
   
    
%       I think it's great to leave it here. this provides better thresholds
%     [p8,useless] = size(find(bwperim(mask,8)>0));
%     circularity= p8*p8/area;
