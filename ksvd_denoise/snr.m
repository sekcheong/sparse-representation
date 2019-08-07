function [ snr ] = snr( imgnoisy, img )    
    noise = imgnoisy - img;
    snr = 20 * log10( sqrt(sum(sum(img.^2))) / sqrt(sum(sum(noise.^2))));
end
