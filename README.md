# Constrained Optimization for Image Denoising using Total Variation

This project tackles the problem of image denoising by formulating a constrained optimization model aimed at recovering a clean image 𝑋, which is as close as possible to the noisy observation 𝐼𝑚. Instead of relying on traditional denoising techniques such as Gaussian filters, median filters, or deep learning models, this work focuses on a Total Variation (TV)-based approach, known for preserving edges while removing noise.

**Objective Function**
---
We aim to solve the following optimization problem:

Minimize: (1/2) * ||X - Im||_F^2 + β * TV(X)

where:
- X is the restored image
- Im is the noisy input image
- ||·||_F is the Frobenius norm
- TV(X) is the total variation of the image

**Methods Implemented**
---
The following optimization algorithms were used to solve the problem:

- Projected Gradient Descent: Implements iterative updates with explicit projection onto constraints.
- ADMM (Alternating Direction Method of Multipliers): A splitting technique particularly suited for non-smooth problems like TV regularization.
- fmincon: MATLAB’s built-in constrained optimization solver, used to validate results and compare performance.

**Code Structure**
---
- main.m: Entry point to run different optimization methods and compare results.
- projected_gradient_method.m, admm_denoising_tv.m, solve_fmincon.m: Implementations of the respective methods.
- compute_gradient.m, compute_objective.m, total_variation.m: Core utility functions.
- project_onto_constraints.m: Handles projection in constrained methods.
- denoising_gui.m: Simple GUI for visualizing results.
- Test images: cameraman.jpg, fata.jpg
