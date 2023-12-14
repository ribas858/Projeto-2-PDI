function destaque_cor(original, camada_segmentada, str)

    img = zeros(size(original), 'like', original);
    
    original_cinza = rgb2gray(original);
    original_cinza(camada_segmentada) = 0;

    original_rgb_sem_cor = im2uint8(ind2rgb(original_cinza, gray(256)));
    
    for canal = 1:3
        img(:, :, canal) = original(:, :, canal) .* uint8(camada_segmentada);
    end
    
    subplot(1, 2, 1);
    imshow(original);
    title('Onion');

    subplot(1, 2, 2);
    imshow(original_rgb_sem_cor + img);
    title("Segmentação: " + str);
end