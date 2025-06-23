function val = compute_objective_vectorized(x, Im, beta, epsilon)
    [m, n] = size(Im);
    X = reshape(x, m, n);
    fidelity = 0.5 * sum((X(:) - Im(:)).^2);
    tv = total_variation(X, epsilon);
    val = fidelity + beta * tv;
end
