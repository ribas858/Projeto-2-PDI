addpath('funcs/');
clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Questão 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Leitura da imagem
img = imread('brain.png');
% Converter para Nivel de cinza
img_gray = rgb2gray(img);

% Aplicando o gaussiano
img_gauss = gaussiano_freq(img_gray, 100);

% Aplicando o filtro de mediana
brain = medfilt2(img_gauss, [7 7]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT do resultado dos filtros

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
% PLOT dos histogramas

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

% Binarização da borda
limiar1 = 250 / 255;
borda = imbinarize(brain, limiar1);

% Binarização do tumor
limiar2 = 151 / 255;
brain_bin = imbinarize(brain, limiar2);

subplot(2, 2, 1);
imshow(brain_bin);
title('Binarização: Brain');

subplot(2, 2, 2);
imshow(borda);
title('Binarização: Borda');

% Subtração da borda
brain_bin = brain_bin - borda;
subplot(2, 2, 3);
imshow(brain_bin);
title('Binarização: Brain (-) Borda');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Elemento estruturante ponta
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
% Abertura
img_0 = imopen(brain_bin, disk0);
imshow(img_0);
title('Abertura "disk" tam : 3');

subplot(2, 2, 3);
% Abertura
img_1 = imopen(img_0, meu_elemento0);
imshow(img_1);
title('Abertura "meu elemento"');


subplot(2, 2, 4);
% Dilatação
img_2 = imdilate(img_1, meu_elemento0);
imshow(img_2);
title('Dilatação "meu elemento"');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf;
% Erosão
img_3 = imerode(img_2, square0);
imshow(img_3);
title('Erosão "square0"');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Função de componentes conectados
CC = bwconncomp(img_3);
num_objetos = CC.NumObjects;

% Vetor para armazenar os tamanhos em pixels de cada objeto
sizes_objs = zeros(1, num_objetos);

% Obtem os tamanhos e armazena em sizes_objs
for i = 1 : num_objetos
    sizes_objs(i) = size(CC.PixelIdxList{i}, 1);
end
% Tamanho do maior objeto
size_maior_objeto = max(sizes_objs);

% Indice do objeto de maior tamanho
maior_objeto_id = find(sizes_objs == size_maior_objeto);

% Obtem o maior objeto atravez do seu id
pixels_objeto = CC.PixelIdxList{maior_objeto_id}; 

% Imagem zerada
img_final = zeros(size(img_3));

% Adiciona o maior objeto a imagem final
img_final(pixels_objeto) = 1;

% Mostra a imagem final, contendo o maior objeto conexo
imshow(img_final);
title('Maior Objeto Conexo');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disk1 = strel('disk', 3);

% Dilatação
a = imdilate(img_final, disk1);

% Erosão
b = imerode(img_final, disk1);

% Extração de fronteiras, ditalação - erosao
bordas = a - b;
imshow(bordas);
title('Fronteiras');

fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Converte para bin a imagem com as fronteiras
bordas = logical(bordas);

% Cor vermelha
r = [255, 0, 0];


[h, w] = size(bordas);
% Cria imagem zerada RGB
borda_red = zeros(h, w, 3, 'uint8');

% Encontra os pixels 1s na imagem bin bordas
pixels_1s = find(bordas);

% Retorna a quantidade de pixels 1s
num_pixels = numel(pixels_1s);

% Copia todos os pixels para borda red, adicionando a cor vermelha
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

% Exibe a imagem original, sem filtro, com o tumor destacado
imshow(img_gray + borda_red);
title('Tumor Destacado');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Questão 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ler imagem
onion = imread('onion.png');

% Obtem as medidas da imagem
[l, c, camadas] = size(onion);

% Gera o vetor de dados
y = double(reshape(onion, l * c, camadas));

% TESTE PARA DESCOBRIR O NUMERO DE CLUSTERS IDEAL PARA SEGMENTAR A PIMENTA
% =========================================================================
% num_cluster_teste = 8;
% Idx = kmeans(y, num_cluster_teste);
% for i = 1 : num_cluster_teste
%       imshow(reshape(Idx == i, l, c));
%       disp("cluster " + i); pause;
% end
% disp("fim");
% =========================================================================
% =========================================================================
% O MELHOR VALOR FOI -> 8
valor_final_p = 8;

num_cluster_final = valor_final_p;

% Cor da pimenta aproximada
cor_pimenta = double([142, 29, 42]);

% K-means retorna indices dos clusters e vetor de centroides
[Idx, C, ~] = kmeans(y, num_cluster_final);

% Retorna id de centroide mais proximo da cor da pimenta
id_centroide = centroide_cor_mais_proximo(C, cor_pimenta);

% Gera imagem binaria com o cluster segmentado
pimentas = reshape(Idx == id_centroide, l, c);

figure;
destaque_cor(onion, pimentas, "Pimentas");
fprintf('\n');
disp('Enter... para continuar'); pause;
fprintf('\n');

% TESTE PARA DESCOBRIR O NUMERO DE CLUSTERS IDEAL PARA SEGMENTAR A CEBOLA
% =========================================================================
% num_cluster_teste = 6;
% Idx = kmeans(y, num_cluster_teste);
% for i = 1 : num_cluster_teste
%       imshow(reshape(Idx == i, l, c));
%       disp("cluster " + i); pause;
% end
% disp("fim");
% =========================================================================
% =========================================================================
% O MELHOR VALOR FOI -> 6
valor_final_c = 6;

num_cluster_final = valor_final_c;

% Cor da cebola aproximada
cor_cebola = double([251, 224, 195]);

% K-means retorna indices dos clusters e vetor de centroides
[Idx, C, ~] = kmeans(y, num_cluster_final);

% Retorna id de centroide mais proximo da cor da cebola
id_centroide = centroide_cor_mais_proximo(C, cor_cebola);

% Gera imagem binaria com o cluster segmentado
cebola = reshape(Idx == id_centroide, l, c);

destaque_cor(onion, cebola, "Cebola");
disp('Enter... para continuar'); pause;
fprintf('\n');


% Numero maximo de clusters a serem testatos
clusters_teste = 20;

% Vetor para armazenar a inercia dos clusters
inercia = zeros(clusters_teste, 1);

disp('Gerando gráfico.....');

% Chama a função K-means com diferentes valores de K, para encontrar o K
% ideal
for k = 1 : clusters_teste
    [~, ~, soma_dists] = kmeans(y, k);
    % Obtem a soma das distancias quadraticas e faz o somatorio de cada
    % cluster, gerando a inercia k
    inercia(k) = sum(soma_dists);
end

% Plota Grafico exemplificando o metodo do cotovelo
figure;
plot(1:clusters_teste, inercia, 'o-', 'LineWidth', 2, 'Color', 'g');
title('Método do Cotovelo');
xlabel('Número de Clusters (k)');
ylabel('Inércia'); grid on;
line([9, 9], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 2);
text(10, mean(ylim)/2, 'Cotovelo', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'r', 'FontWeight', 'bold');

disp('Enter... para continuar'); pause;
fprintf('\n');

% Numero de classes k ideal encontrado == 9
num_cluster = 9;

% Chama kmeans com K ideal
Idx = kmeans(y, num_cluster);

% Exibe o resultado da segmentação com o K ideal
for i = 1 : num_cluster
    camada = reshape(Idx == i, l, c);

    str = "Camada: " + i;
    destaque_cor(onion, camada, str);
    
    pause;
end
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%