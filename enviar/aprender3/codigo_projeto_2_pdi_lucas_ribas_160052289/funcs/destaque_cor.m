function destaque_cor(original, camada_segmentada, str)

    % Gera imagem preta
    img = zeros(size(original), 'like', original);
    
    % Converte para niveis de cinza
    original_cinza = rgb2gray(original);
    
    % Atribui o valor zero aos pixels da imagem, onde a camada_segementada for '1',
    % assim subtraindo o local para inserir a camada segmentada com cor
    original_cinza(camada_segmentada) = 0;

    % Converte a imagem RGB cinza para Uint8
    original_rgb_sem_cor = im2uint8(ind2rgb(original_cinza, gray(256)));
    
    % Multiplica a camada segmenta para inserir na imagem toda preta
    for canal = 1:3
        img(:, :, canal) = original(:, :, canal) .* uint8(camada_segmentada);
    end
    
    subplot(1, 2, 1);
    imshow(original);
    title('Onion');

    subplot(1, 2, 2);
    % Mostra a imagem cinza adicionada a camada segementada com cor
    imshow(original_rgb_sem_cor + img);
    title("Segmentação: " + str);
end