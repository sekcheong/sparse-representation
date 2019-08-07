function [patches, widx] = createPatches(image, blockSize)
    [M, N] = size(image);
    p_n=blockSize;
    n = p_n*p_n;
    patches_count = (M - p_n + 1) * (N - p_n + 1);
    patches = zeros(n, patches_count);
    widx = zeros(2, patches_count);
    patch_index = 1;
    for i = 1:M - p_n + 1
        for j = 1:N - p_n + 1
            patch = image(i : i + p_n - 1, j : j + p_n - 1);
            patches(:, patch_index) = patch(:);
            widx(:, patch_index) = [i; j];
            patch_index = patch_index + 1;
        end
    end
