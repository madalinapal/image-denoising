function [X, obj_vals, grad_norms, step_norms, times] = frank_wolfe_method(Im, beta, max_iter, epsilon, tol)
    X = Im;  % inițializare
    obj_vals = zeros(max_iter, 1);
    grad_norms = zeros(max_iter, 1);
    step_norms = zeros(max_iter, 1);
    times = zeros(max_iter, 1);

    tic;
    k = 1;

    grad = compute_gradient(X, Im, beta, epsilon);
    grad_norm = norm(grad(:), 2);

    while k <= max_iter && grad_norm > tol
        grad_norms(k) = grad_norm;

        % Direcție Frank-Wolfe: alegerea extremă a colțului [0,255]
        S = zeros(size(X));
        S(grad < 0) = 255;

        % Pas standard Frank-Wolfe
        gamma = 2 / (k + 2);

        % Actualizare punct
        X_new = (1 - gamma) * X + gamma * S;
        step_norms(k) = norm(X_new - X, 'fro');

        X = X_new;

        obj_vals(k) = compute_objective(X, Im, beta, epsilon);
        times(k) = toc;

        if mod(k, 100) == 0
            fprintf('FW iter %4d: obj = %.6f, ||grad|| = %.6e, step = %.6e, time = %.2f s\n', ...
                k, obj_vals(k), grad_norm, gamma, times(k));
        end

        % Recalcul gradient pentru iterația următoare
        grad = compute_gradient(X, Im, beta, epsilon);
        grad_norm = norm(grad(:), 2);

        k = k + 1;
    end

    % Trunchiere vectori la dimensiunea reală
    obj_vals = obj_vals(1:k-1);
    grad_norms = grad_norms(1:k-1);
    step_norms = step_norms(1:k-1);
    times = times(1:k-1);
end
