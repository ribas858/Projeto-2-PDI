addpath('funcs/');
clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

onion = imread('onion.png');
% imshow(onion);

[l, c, camadas] = size(onion);

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
cor_pimenta = double([142, 29, 42]);

[Idx, C, ~] = kmeans(y, num_cluster_final);

id_centroide = centroide_cor_mais_proximo(C, cor_pimenta);

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
cor_cebola = double([251, 224, 195]);

[Idx, C, ~] = kmeans(y, num_cluster_final);

id_centroide = centroide_cor_mais_proximo(C, cor_cebola);

cebola = reshape(Idx == id_centroide, l, c);

destaque_cor(onion, cebola, "Cebola");
disp('Enter... para continuar'); pause;
fprintf('\n');



clusters_teste = 20;
 
inercia = zeros(clusters_teste, 1);
disp('Gerando gráfico.....')
for k = 1 : clusters_teste
    [~, ~, soma_dists] = kmeans(y, k);
    inercia(k) = sum(soma_dists);
end

figure;
plot(1:clusters_teste, inercia, 'o-', 'LineWidth', 2, 'Color', 'g');
title('Método do Cotovelo');
xlabel('Número de Clusters (k)');
ylabel('Inércia'); grid on;
line([9, 9], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 2);
text(10, mean(ylim)/2, 'Cotovelo', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'r', 'FontWeight', 'bold');

disp('Enter... para continuar'); pause;
fprintf('\n');


num_cluster = 9;
Idx = kmeans(y, num_cluster);

for i = 1 : num_cluster
    camada = reshape(Idx == i, l, c);

    str = "Camada: " + i;
    destaque_cor(onion, camada, str);
    
    pause;
end
fprintf('\n');


