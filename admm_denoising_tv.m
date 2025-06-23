function [X, obj_vals] = admm_denoising_tv(Im_noisy, beta, epsilon, rho, max_iter, tol)
    Im_noisy = im2double(Im_noisy);
    [m, n] = size(Im_noisy);

    % Initializare
    X = Im_noisy;
    Z = X;
    U = zeros(m, n);
    obj_vals = zeros(max_iter, 1);

    k = 1;
    primal_res = inf;

    while k <= max_iter && primal_res > tol
        % === X-update ===
        X = (Im_noisy + rho * (Z - U)) / (1 + rho);

        % === Z-update folosind prox_tv_iterative ===
        V = X + U;
        Z = prox_tv_iterative(V, beta / rho, epsilon, 50);  % 50 pasi interni

        % === U-update ===
        U = U + X - Z;

        % === Functia obiectiv ===
        dx = [diff(Z,1,1); zeros(1,n)];
        dy = [diff(Z,1,2), zeros(m,1)];
        tv_val = sum(sum(sqrt(dx.^2 + dy.^2 + epsilon)));
        obj_vals(k) = 0.5 * norm(Im_noisy(:) - Z(:))^2 + beta * tv_val;

        % === Conditie de oprire ===
        primal_res = norm(X(:) - Z(:));

        % === Afisare progres ===
        if mod(k, 50) == 0 || primal_res < tol
            fprintf('ADMM iter %d: obj = %.4f, reziduu = %.2e\n', k, obj_vals(k), primal_res);
        end

        k = k + 1;
    end

    % Trunchiere vector obiectiv dacă s-a terminat devreme
    obj_vals = obj_vals(1:k-1);

    % Z este imaginea finală restaurată
    X = Z;
end
