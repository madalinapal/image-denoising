function Z = prox_tv_iterative(V, lambda, epsilon, inner_iter)
    Z = V;
    [m, n] = size(Z);

    for t = 1:inner_iter
        alfa = 1/sqrt(t);
        dx = [diff(Z,1,1); zeros(1,n)];
        dy = [diff(Z,1,2), zeros(m,1)];
        grad_norm = sqrt(dx.^2 + dy.^2 + epsilon);

        dx_bar = dx ./ grad_norm;
        dy_bar = dy ./ grad_norm;

        div_x = [-dx_bar(1,:); -diff(dx_bar,1,1)];
        div_y = [-dy_bar(:,1), -diff(dy_bar,1,2)];
        tv_grad = div_x + div_y;

        total_grad = lambda * tv_grad + (Z - V);

        Z = Z - alfa * total_grad;
    end

    Z = min(max(Z, 0), 255);  
end
