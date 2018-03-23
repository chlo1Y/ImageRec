poke=imread('poke.jpg');
poke=rgb2gray(poke)
stdiva=std2(poke);
coeff=1/(stdiva*sqrt(2*pi));
gfilter=coeff* [exp(-8/(2*stdiva^2)) exp(-5/(2*stdiva^2)) exp(-2/(2*stdiva^2)) exp(-5/(2*stdiva^2)) exp(-8/(2*stdiva^2));...
    exp(-5/(2*stdiva^2)) exp(-2/(2*stdiva^2)) exp(-1/(2*stdiva^2)) exp(-2/(2*stdiva^2)) exp(-5/(2*stdiva^2));...
    exp(-2/(2*stdiva^2)) exp(-1/(2*stdiva^2)) exp(0/(2*stdiva^2)) exp(-1/(2*stdiva^2)) exp(-2/(2*stdiva^2));...
    exp(-5/(2*stdiva^2)) exp(-2/(2*stdiva^2)) exp(-1/(2*stdiva^2)) exp(-2/(2*stdiva^2)) exp(-5/(2*stdiva^2));...
    exp(-8/(2*stdiva^2)) exp(-5/(2*stdiva^2)) exp(-2/(2*stdiva^2)) exp(-5/(2*stdiva^2)) exp(-8/(2*stdiva^2))];
smoothImg=filter2(gfilter,poke);
% subplot(1,2,1);
% mesh(gfilter);
% title("guess filter");

imtool(poke);
imtool(uint8(smoothImg));
trueGaussian= fspecial('gaussian', 5);
realSmooth=filter2(trueGaussian,poke);
imtool(uint8(realSmooth));
%mesh(trueGaussian);
% subplot(1,2,2);
% mesh(trueGaussian);
% title("real filter");