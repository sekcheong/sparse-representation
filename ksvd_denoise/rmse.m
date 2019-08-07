function r = rmse( X, Y )
    [M, N] = size(X);
    r = sqrt( sum(sum((X - Y).^2)) / (M * N) );
end