addpath('funcs/');
clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = imread('brain.png');
img_gray = rgb2gray(img);


[h, w] = size(img_gray);

img_gauss = gaussiano_freq(img_gray, 100);


brain = medfilt2(img_gauss, [7 7]);



% subplot(1, 2, 1);
% imshow(img_gray);
% title('Original');
%  
% subplot(1, 2, 2);
% imshow(brain);
% title('Gaussiano(100) + Mediana[7, 7]');

% 
% figure;
% imhist(brain);
% title('Histograma Pos-Filtros');

limiar1 = 254 / 255;
borda = imbinarize(brain, limiar1);

limiar2 = 151 / 255;
brain_bin = imbinarize(brain, limiar2);
% imshow(brain_bin);
brain_bin = brain_bin - borda;
% imshow(brain_bin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% limiar = 151 / 255;
% brain_bin = imbinarize(brain, limiar);

% figure;
% subplot(1, 2, 1);
% imshow(brain);
% title('Brain');
% 
% subplot(1, 2, 2);
% imshow(brain_bin);
% title('Brain Binarizado');

% Abertura e Fechamento
% figure;
% subplot(1, 3, 1);
% imshow(brain_bin);

ponta = [
    0 0 0 0 1 0;
    0 0 0 1 0 0;
    0 0 1 1 0 0;
    0 1 1 1 1 0;
    0 0 0 0 0 0;
    0 0 0 0 0 0;
];
meu_elemento0 = strel('arbitrary', ponta);
square0 = strel('square', 3);
disk0 = strel('disk', 3);

img_0 = imopen(brain_bin, disk0);
imshow(img_0);
title('Abertura "disk" tam : 3'); pause;

img_1 = imopen(img_0, meu_elemento0);
imshow(img_1);
title('Abertura "meu_elemento"'); pause;



img_2 = imdilate(img_1, meu_elemento0);
imshow(img_2);
title('Dilatação "meu_elemento"'); pause;

img_3 = imerode(img_2, square0);
imshow(img_3);
title('Erosão "meu_elemento"'); pause;
 
img_4 = imclose(img_3, meu_elemento0);
imshow(img_4);
title('Fechamento "meu_elemento"'); pause;
 
img_5 = imopen(img_4, meu_elemento0);
imshow(img_5);
title('Abertura "meu_elemento"'); pause;

img_6 = imclose(img_5, meu_elemento0);
imshow(img_6);
title('Fechamento "meu_elemento"'); pause;


CC = bwconncomp(img_6);
num_objetos = CC.NumObjects;
sizes_objs = zeros(1, num_objetos);


for i = 1 : num_objetos
    sizes_objs(i) = size(CC.PixelIdxList{i}, 1);
end
size_maior_objeto = max(sizes_objs);

maior_objeto_id = find(sizes_objs == size_maior_objeto);

pixels_objeto = CC.PixelIdxList{maior_objeto_id}; 

img_final = zeros(size(img_6));

img_final(pixels_objeto) = 1;

imshow(img_final);
title('Maior Objeto Conexo'); pause;

disk1 = strel('disk', 3);

a = imdilate(img_final, disk1);
b = imerode(img_final, disk1);

bordas = a - b;
imshow(bordas);
title('Fronteiras'); pause;

bordas = logical(bordas);

r = [255, 0, 0];

[h, w] = size(bordas);
borda_red = zeros(h, w, 3, 'uint8');

pixels_1s = find(bordas);
num_pixels = numel(pixels_1s);

for i = 1:num_pixels
    [x, y] = ind2sub(size(bordas), pixels_1s(i));
    borda_red(x, y, :) = r;
end

% Exibir resultados
subplot(1, 2, 1);
imshow(bordas);
title('Imagem Binária Original');

subplot(1, 2, 2);
imshow(borda_red);
title('Imagem Colorida');

imshow(img_gray + borda_red);



