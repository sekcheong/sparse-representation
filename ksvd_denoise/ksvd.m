function [ D, A, rmses, sparsity ] = ksvd(D, X, k, L, epsilon, max_iter, print )

    [n, ~] = size(X);
    % Generate column normalized positive D
    %D = randn(n, k);
    D = D - min(min(D));
    D = bsxfun(@rdivide, D, sqrt(sum(D.^2)));
    
    rmses = zeros(1, max_iter);
    sparsity = zeros(1, max_iter);
    
    last_err = 0;
    
    A = omp(D, k, X, L, epsilon);
    
    [M_A, N_A] = size(A);
    
    size_A = M_A * N_A;
    
    Il_empty = 1:N_A;
    
    for iter = 1:max_iter
        tic;
        R = X - D * A;
        for k_index = 1:k
            Il = find(A(k_index, :) ~= 0);
            %fprintf('\t%d\n', length(Il));
            if isempty(Il)
                Il = Il_empty;
            end
            Ri = R(:, Il) + D(:, k_index) * A(k_index, Il);
            [U, S, V] = svds(Ri, 1);

            D(:, k_index) = U;
            A(k_index, Il) = S*V';
            R(:, Il) = Ri - D(:, k_index) * A(k_index, Il);
        end
        
        A = omp(D, k, X, L, epsilon);
        
        sparsity(iter) = 100*(1 - double(sum(sum(A ~= 0)))/size_A);
        
        err = rmse(X, D * A);
        
        rmses(iter) = err;
        
        t = toc;
        
        if print
            fprintf('\tIteration %d: %.4fs, RMSE = %.4f, Sparsity = %.4f\n', iter, t, rmses(iter), sparsity(iter));
        end
        
        if abs(err - last_err) < 1e-4
            break;
        end
        
        last_err = err;
    end
    rmses = rmses(1:iter);
    sparsity = sparsity(1:iter);
end


% Generate column normalized positive D
%     D = randn(n, k);
%     D = D - min(min(D));
%     D = bsxfun(@rdivide, D, sqrt(sum(D.^2)));
