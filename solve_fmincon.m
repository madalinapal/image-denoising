function [X_out, obj_vals, grad_vals, step_vals, time_vals, exitflag, output_message] = solve_fmincon(Im_noisy, beta, ...
    epsilon, max_iter)

    [m, n] = size(Im_noisy);
    x0 = Im_noisy(:);
    lb = zeros(size(x0));
    ub = ones(size(x0));

    obj_vals = [];
    grad_vals = [];
    step_vals = [];
    time_vals = [];
    tic;

    % Variabila persistenta pentru pasul anterior
    prev_x = x0;

    % Functia obiectiv cu gradient
    function [f, g] = obj_fun(x)
        X = reshape(x, m, n);
        f = 0.5 * sum((x - Im_noisy(:)).^2) + beta * total_variation(X, epsilon);

        if nargout > 1
            gX = compute_gradient(X, Im_noisy, beta, epsilon);
            g = gX(:);
        end

        obj_vals(end+1) = f;
        grad_vals(end+1) = norm(g);
        if numel(obj_vals) == 1
            step_vals(end+1) = NaN;
        else
            step_vals(end+1) = norm(x - prev_x);
        end
        time_vals(end+1) = toc;
        prev_x = x;
    end

    % Optiuni pentru fmincon
    options = optimoptions('fmincon', ...
        'Algorithm', 'interior-point', ...
        'GradObj', 'on', ...
        'Display', 'none', ...
        'MaxIterations', max_iter, ...
        'OutputFcn', @outfun, ...
        'HessianApproximation', 'lbfgs');

    % Apel fmincon
    [x_opt, ~, exitflag, output] = fmincon(@obj_fun, x0, [], [], [], [], lb, ub, [], options);
    X_out = reshape(x_opt, m, n);
    output_message = output.message;
end

% Funcția OutputFcn pentru afisare la fiecare 100 de iteratii
function stop = outfun(x, optimValues, state)
    stop = false;
    switch state
        case 'iter'
            if mod(optimValues.iteration, 100) == 0
                fprintf('Iter: %d, Obj: %.4e\n', optimValues.iteration, optimValues.fval);
            end
    end
end
