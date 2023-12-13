function imagem_filtrada = gaussiano_freq(img, sig)
  
  imagem = double(img);

  [h, w] = size(imagem);

  imagem_dft = ( fftshift(fft2(imagem)) );

  
  filtro_gauss = zeros(h, w);
  for i = 1:h
      for j = 1:w
          dist = sqrt( ( i - (h/2) )^2 + ( j - (w/2) )^2);
          result = (dist^2) / (2 * (sig^2));
          
          filtro_gauss(i, j) = exp(-result);
      end
  end
  
%   figure;
%   imshow(filtro_gauss);

  imagem_dft_filtro = imagem_dft .* filtro_gauss;

  imagem_filtrada = ifft2(ifftshift(imagem_dft_filtro));

  imagem_filtrada = uint8(abs(imagem_filtrada));
  
end