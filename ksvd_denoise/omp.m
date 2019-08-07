function [ A ] = omp( D, k, X, L, epsilon )

    [~, sample_size] = size(X);

    A = zeros(k, sample_size);
    
    for s = 1:sample_size
        residue = X(:, s);
        index_weights = zeros(k, 1);
        
        for k_index = 1:L
            weights = D' * residue + index_weights;
            [~, I] = max(abs(weights));
            A(I, s) = weights(I);
        
            index_weights(I) = NaN;
        
            residue = residue - A(I, s) * D(:, I);
            rmse_residue = sqrt(residue' * residue);
            if rmse_residue <= epsilon
                break;
            end
        end
        
    end
end