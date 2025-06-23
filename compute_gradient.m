function grad = compute_gradient(X, Im, beta, epsilon)
    [m, n] = size(X);

    dx = [diff(X,1,1); zeros(1,n)];
    dy = [diff(X,1,2), zeros(m,1)];

    G = sqrt(dx.^2 + dy.^2 + epsilon);

    dx_bar = dx ./ G;
    dy_bar = dy ./ G;

    dxT = [-dx_bar(1,:); -diff(dx_bar,1,1)];
    dyT = [-dy_bar(:,1), -diff(dy_bar,1,2)];

    grad_tv = dxT + dyT;

    grad_data = X - Im;

    grad = grad_data + beta * grad_tv;
end
