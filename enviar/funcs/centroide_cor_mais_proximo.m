function id_centroide = centroide_cor_mais_proximo(C, cor)

    % Calcula as diferenças euclidianas
    diferencas_euclidianas = double(sqrt(sum((C - cor).^2, 2)));

    % Encontra o indice do centroide mais proximo com base nas diferenças
    % euclidianas
    indc = find (diferencas_euclidianas == min(diferencas_euclidianas) );

    
    centroide_cor_mais_proximo = C(indc, :);

    disp(['Centroide mais próximo de [' num2str(cor) '] é [' num2str(centroide_cor_mais_proximo) ']']);
    
    % Retorna o indice do centroide mais proximo, no caso a cor 
    id_centroide = indc;

end