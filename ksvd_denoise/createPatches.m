function [patches, widx] = createPatches(image, blockSize)
%createPatches Create patches from a given image
%  [patches windowIndex] = createPatches(X) 
%  patches - an array to hold the blockSize x blockSize patches
%  widx - widow index, this vaule can be used for reconstructing image 
%         from patches 
    [M, N] = size(image);
    pn = blockSize;
    n = pn * pn;
    pcount = (M - pn + 1) * (N - pn + 1);
    patches = zeros(n, pcount);
    widx = zeros(2, pcount);
    p = 1;
    for i = 1:M - pn + 1
        for j = 1:N - pn + 1
            patch = image(i : i + pn - 1, j : j + pn - 1);
            patches(:, p) = patch(:);
            widx(:, p) = [i; j];
            p = p + 1;
        end
    end
