clear all;
image = 'shapes.png';
index=3;
[elongation, circularity]= lab4_function (image, index);

if(elongation>=1 && elongation <=1.001 && circularity>15 && circularity <19)
    fprintf('%d\t This is a square\n', index);
end 

if((elongation>=1.7 && elongation <4 && circularity>15 && circularity <25))
    fprintf('%d\t This is an ellipse\n', index);
end 

if((elongation>=1.6 && elongation <=3 && circularity>16 && circularity <20) ||...
        (elongation>4 && circularity>25))
    fprintf('%d\t This is a rectangle\n', index);
end 

if(elongation>=1.0005 && elongation <=1.1 && circularity>13 && circularity <14)
    fprintf('%d\t This is a circle\n', index);
end 


