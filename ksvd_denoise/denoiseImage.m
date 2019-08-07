function image = denoiseImage(noisyimg, D, alpha, sigma, blockSize, widx)
    lambda = 30/sigma;
    D_A = D * alpha;
    p_n = blockSize;
    [M, N] = size(noisyimg);
    pcount = (M - p_n + 1) * (N - p_n + 1);
    image = zeros(M, N);
    c = zeros(M, N);

    pshape = [p_n, p_n];
    onesp = ones(p_n, p_n);

    for p=1:pcount
        patch = reshape(D_A(:, p), pshape);
        image(widx(1, p):widx(1, p) + p_n - 1, widx(2, p):widx(2, p) + p_n - 1) =  image(widx(1, p):widx(1, p) + p_n - 1, widx(2, p):widx(2, p) + p_n - 1) + patch;
        c(widx(1, p):widx(1, p) + p_n - 1, widx(2, p):widx(2, p) + p_n - 1) = c(widx(1, p):widx(1, p) + p_n - 1, widx(2, p):widx(2, p) + p_n - 1) + onesp;
    end
    
    image = image + lambda * noisyimg;
    c = c + lambda;
    image = image./c;