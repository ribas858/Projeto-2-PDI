function C_new = remover_centroide(C, centroide)

    % Encontrar índice da linha a ser removida
    indc = ismember(C, centroide, 'rows');

    C_new = C;
    C_new(indc, :) = [];
    
end