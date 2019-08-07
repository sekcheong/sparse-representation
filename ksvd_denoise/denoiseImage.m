function image = denoiseImage(noisyimg, D, alpha, sigma, blockSize, widx)
    lambda = 30/sigma;
    DAlpha = D * alpha;
    pn = blockSize;
    [M, N] = size(noisyimg);
    pcount = (M - pn + 1) * (N - pn + 1);
    
    image = zeros(M, N);
    c = zeros(M, N);

    pshape = [pn, pn];
    onesp = ones(pn, pn);

    for p=1:pcount
        patch = reshape(DAlpha(:, p), pshape);
        image(widx(1, p):widx(1, p) + pn - 1, widx(2, p):widx(2, p) + pn - 1) =  image(widx(1, p):widx(1, p) + pn - 1, widx(2, p):widx(2, p) + pn - 1) + patch;
        c(widx(1, p):widx(1, p) + pn - 1, widx(2, p):widx(2, p) + pn - 1) = c(widx(1, p):widx(1, p) + pn - 1, widx(2, p):widx(2, p) + pn - 1) + onesp;
    end
    
    image = image + lambda * noisyimg;
    c = c + lambda;
    image = image./c;