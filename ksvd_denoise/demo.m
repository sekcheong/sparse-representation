%% Clear
close all; clc; clear all;


%% Read the image data
imgfile = 'barbara.png';
img = imread(imgfile);
img = double(img);
figure;
imshow(img/255);
title('Original Image');

% Get the dimision if the image 
p = ndims(img);


%% Add Gaussian noise with sigma 20
disp(' ');
disp('Generating noisy image...');

% sigma the variance of noise Gaussian, try different values like 5, 10, 35
sigma = 20;
n = randn(size(img)) * sigma;
imgnoise = img + n;
figure;
imshow(imgnoise/255);
r = snr(img, imgnoise);
title(sprintf('Noisy image, SNR = %.2fdB', r));


%% Create DCT coefficiencies dictionary 
blockSize = 8;
dictSize = 256;
dict = odctndict(blockSize, dictSize, p);


%% Visualized the DCT dictionary
dictImage = dict2image(dict, blockSize, dictSize);
figure;
imshow(imresize(dictImage,4,'nearest'));
title('DCT dictionary');


%% Create training image patches from the original imnage
[patches, widx] = createPatches(imgnoise, blockSize);


%% Displage the image patches 
dictImage = dict2image(patches, blockSize, dictSize);
figure;
imshow(imresize(dictImage,4,'nearest'));
title('Sample patches');


%% Using K-SVD to denosing
disp(' ');
disp('Running K-SVD for denosing...');

k = dictSize;

sparsity = 0.25;

L = round(k * sparsity);

M = 15;

C = 0.95; %1.15;

epsilon = (C*sigma)^2;

%%We use the DCT dictionary for the K-SVD, it is also possible to use 
%%a random column vector as the dictionary. To use random vector dictionary
%%uncomment the following lines of code. 

%%Generate column normalized positive dictionary
%[n, ~] = size(imgnoise);
%dict = randn(n, k);

[D, alpha, err, sparsity] =  ksvd(dict, patches, k, L, epsilon, M, 1);


%% Visualization the learned dictionary
dictImage = dict2image(D, blockSize, dictSize);
figure
imshow(imresize(dictImage,4,'nearest'));
title('Learned Dictionary');


%% Denoise the image
dimg = denoiseImage(imgnoise, D, alpha, sigma, blockSize, widx);
figure;
imshow(dimg/255);
r = snr(img, dimg);
title(sprintf('Denoised image, SNR = %.2fdB', r));
