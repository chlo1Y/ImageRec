clear;
img= imread('c1.tiff');
% img= rgb2gray(img);
imgRe= imresize(img,0.5,'bilinear');
imgEdge= edge(imgRe,'canny');
imtool(imgEdge);
[height,width]= size(imgEdge);
score =1;
mask = zeros(size(imgRe));

smallRadius=15;
largeRadius=70;
targetR=largeRadius;
vote = zeros(height, width, targetR);

for row=1:height
    for column=1:width
        for radius= smallRadius:largeRadius
            for angle =1:360
                if(imgEdge(row, column)==1)
                    pointX=round(row-radius*cos(angle/180*pi));
                    pointY= round(column-radius*sin(angle/180*pi));
                    if(pointX>0 && pointX<=height && pointY>0 && pointY<=width)                
                        vote(pointX, pointY, radius)=vote(pointX,pointY,radius)+1;
                    end 
                end
            end
        end
    end
end

peaks=zeros(height, width, largeRadius);
threshold =190;
for rad= smallRadius : largeRadius
    for row=1:height
        for column=1:width
             if (vote(row,column, rad)> threshold)
                 peaks(row,column,rad)=1;
             end
        end
    end
end 

[circleX, circleY, circleR] = ind2sub(size(peaks),find(peaks> 0.7));
%mask(sub2ind(size(mask), circleX, circleY)) = 1;
% imshow(mask);

imshow(imgRe);
hold on;
for i = 1 : size(circleX(:,1), 1)
    r = circleR(i);
%     display(r);
    d=2*r;
    rectangle('Position', [circleY(i)-r circleX(i)-r d d], 'Curvature', [1 1], 'EdgeColor', 'red');
%     display([circleX(i), circleY(i)]);
    plot(circleY(i), circleX(i), 'w+');
end
