function X_proj = project_onto_constraints(X)
    X_proj = min(max(X, 0), 255);
end
