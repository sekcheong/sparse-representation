function [alpha_hat,errors] = OMP(D,y,k)
%the two norms of each column of D
D_n = [];
for i = 1:size(D,2)
    D_n(:,i) = D(:,i)/norm(D(:,i),2);
end
%store the columns numbers of chosen atoms
lambdas = [];
%initialize the residual vector as y
r = y';
%store errors (2-norm) of residuals at each step
errors = [norm(r,2)];
for i = 1:k
    %find the maximum indice of the column and denote by t
    [~,lambda] = max(abs(r*D_n));
    lambdas = [lambdas lambda];
    %the column submatrix of A containing the chosed columns
    B = D_n(:,sort(lambdas));
    r = (y - B*inv(B'*B)*B'*y)';
    errors = [errors norm(r,2)];
end
x = inv(B'*B)*B'*y;
alpha_hat = zeros(size(D,2),1);
sort_lambdas = sort(lambdas);
for i = 1:length(sort_lambdas)
    alpha_hat(sort_lambdas(i),1) = x(i);
end
figure(1)
plot(0:10,errors)
title('2-Norm of Residual at Each Iteration')
xlabel('# Iterations')
ylabel('2-Norm of Residual')

end