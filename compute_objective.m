function val = compute_objective(X, Im, beta, epsilon)
    diff = Im - X;
    fidelity = 0.5 * sum(diff(:).^2);
    tv = total_variation(X, epsilon);
    val = fidelity + beta * tv;
end
