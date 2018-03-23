function [horz,vert,sum,rawMag, rawDir, dir]= sobel(grayImg)
fx=1/8*[-1 0 1;-2 0 2;-1 0 1];
fy=1/8*[1 2 1;0 0 0;-1 -2 -1];
horz=filter2(fx,grayImg);
vert=filter2(fy,grayImg);
sum=horz+vert;
rawMag=sqrt(horz.^2+vert.^2);
rawDir=atan2(vert,horz);
dir=rawDir;
rawDir=((rawDir+pi)./(2*pi)).*255;
dir(find(rawMag<10))=0;
dir=((dir+pi)./(2*pi)).*255;
end
