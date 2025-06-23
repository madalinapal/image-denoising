function tv = total_variation(X, epsilon)
    [m, n] = size(X);
    
    dx = [diff(X, 1, 1); zeros(1, n)];
    dy = [diff(X, 1, 2), zeros(m, 1)];

    tv = sum(sum(sqrt(dx.^2 + dy.^2 + epsilon)));
end
