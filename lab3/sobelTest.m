poke=imread('poke.jpg');
poke=rgb2gray(poke);
[pokeH,pokeV, pokeS, pokeM, pokeD, pokeL]=sobel(poke);
imtool(uint8(pokeH * 15)); 
imtool(uint8(pokeV * 15));
imtool(uint8(pokeS *15));
imtool(uint8(pokeM *15));
imtool(uint8(pokeD));
imtool(uint8(pokeL));