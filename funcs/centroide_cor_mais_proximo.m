function id_centroide = centroide_cor_mais_proximo(C, cor)

    diferencas_euclidianas = double(sqrt(sum((C - cor).^2, 2)));

    indc =find (diferencas_euclidianas == min(diferencas_euclidianas) );

    centroide_cor_mais_proximo = C(indc, :);

    disp(['Centroide mais próximo de [' num2str(cor) '] é [' num2str(centroide_cor_mais_proximo) ']']);
    
    id_centroide = indc;

end