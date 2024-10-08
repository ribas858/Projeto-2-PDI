addpath('funcs/');
clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = imread('brain.png');
img_gray = rgb2gray(img);

% [h, w] = size(img_gray);

img_gauss = gaussiano_freq(img_gray, 100);

brain = medfilt2(img_gauss, [7 7]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(1, 2, 1);
imshow(img_gray);
title('Original');
  
subplot(1, 2, 2);
imshow(brain);
title('Gaussiano(100) + Mediana[7, 7]');
fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(1, 2, 1);
imhist(brain);
title('Histograma Pos-Filtros');
line([250, 250], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 2);
text(130, mean(ylim), 'Limiar Borda (250)', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 6);

subplot(1, 2, 2);
imhist(brain);
title('Histograma Pos-Filtros');
line([151, 151], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 2);
text(30, mean(ylim), 'Limiar Tumor (151)', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 6);

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

limiar1 = 250 / 255;
borda = imbinarize(brain, limiar1);

limiar2 = 151 / 255;
brain_bin = imbinarize(brain, limiar2);

subplot(2, 2, 1);
imshow(brain_bin);
title('Binarização: Brain');

subplot(2, 2, 2);
imshow(borda);
title('Binarização: Borda');

brain_bin = brain_bin - borda;
subplot(2, 2, 3);
imshow(brain_bin);
title('Binarização: Brain (-) Borda');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2, 2, 1);
imshow(brain_bin);
title('Brain Bin');

subplot(2, 2, 2);
img_0 = imopen(brain_bin, disk0);
imshow(img_0);
title('Abertura "disk" tam : 3');

subplot(2, 2, 3);
img_1 = imopen(img_0, meu_elemento0);
imshow(img_1);
title('Abertura "meu elemento"');


subplot(2, 2, 4);
img_2 = imdilate(img_1, meu_elemento0);
imshow(img_2);
title('Dilatação "meu elemento"');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf;
img_3 = imerode(img_2, square0);
imshow(img_3);
title('Erosão "square0"');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CC = bwconncomp(img_3);
num_objetos = CC.NumObjects;
sizes_objs = zeros(1, num_objetos);


for i = 1 : num_objetos
    sizes_objs(i) = size(CC.PixelIdxList{i}, 1);
end
size_maior_objeto = max(sizes_objs);

maior_objeto_id = find(sizes_objs == size_maior_objeto);

pixels_objeto = CC.PixelIdxList{maior_objeto_id}; 

img_final = zeros(size(img_3));

img_final(pixels_objeto) = 1;

imshow(img_final);
title('Maior Objeto Conexo');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disk1 = strel('disk', 3);

a = imdilate(img_final, disk1);
b = imerode(img_final, disk1);

bordas = a - b;
imshow(bordas);
title('Fronteiras');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

clf;

imshow(borda_red);
title('Borda Vermelha');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

imshow(img_gray + borda_red);
title('Tumor Destacado');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




