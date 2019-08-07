function [ psnr ] = psnr( imgnoisy, img )
    noise = imgnoisy - img;
    [M, N] = size(noise);       
    psnr = 20 * log10(( 255 )/sqrt(sum(sum(noise.^2))/(M * N)));
end