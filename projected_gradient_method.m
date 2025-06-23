function [X, obj_vals, grad_norms, step_norms, times] = projected_gradient_method(Im, beta, max_iter, epsilon, tol)
    X = Im;  % initializare
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

        step = 1 / sqrt(k);

        X_new = X - step * grad;
        X_new = project_onto_constraints(X_new);
        step_norms(k) = norm(X_new - X, 2);

        X = X_new;
        obj_vals(k) = compute_objective(X, Im, beta, epsilon);
        times(k) = toc;

        if mod(k, 100) == 0
            fprintf('PG iter %4d: obj = %.6f, ||grad|| = %.6e, step = %.6e, time = %.2f s\n', ...
                    k, obj_vals(k), grad_norm, step, times(k));
        end

        grad = compute_gradient(X, Im, beta, epsilon);
        grad_norm = norm(grad(:), 2);

        k = k + 1;
    end

    obj_vals = obj_vals(1:k-1);
    grad_norms = grad_norms(1:k-1);
    step_norms = step_norms(1:k-1);
    times = times(1:k-1);
end
