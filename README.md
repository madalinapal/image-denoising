# Constrained Optimization for Image Denoising using Total Variation 

This project addresses the task of **image denoising** by formulating a **constrained optimization problem** that seeks to recover a clean image \( X \), which is as close as possible to the noisy observation \( Im \). Instead of relying on standard filtering techniques like Gaussian or median filters, or deep learning models, we apply a **Total Variation (TV)**-based method — a powerful approach known for preserving edges while effectively removing noise.

---

##  Objective Function

We aim to solve the following optimization problem:

Minimize: (1/2) * ||X - Im||_F^2 + β * TV(X)

Where:
- `X` is the restored image  
- `Im` is the noisy input image  
- `||·||_F` is the Frobenius norm  
- `TV(X)` is the total variation regularization term  
- `β` is a positive parameter controlling the regularization strength

---

## ⚙ Methods Implemented

We implemented three optimization methods to solve the denoising problem:

- **Projected Gradient Descent**  
  Performs iterative updates followed by projection onto constraints to ensure feasible solutions.

- **ADMM (Alternating Direction Method of Multipliers)**  
  Splits the optimization problem into subproblems, well-suited for non-smooth regularization like TV.

- **`fmincon` Solver (MATLAB built-in)**  
  Used as a baseline for comparison with our custom methods.

---

##  Code Structure

| File                          | Description |
|------------------------------|-------------|
| `main.m`                     | Main entry point to run the experiments |
| `projected_gradient_method.m`| Projected Gradient Descent implementation |
| `admm_denoising_tv.m`        | ADMM solver for TV-regularized denoising |
| `solve_fmincon.m`            | Optimization using MATLAB’s `fmincon` |
| `compute_gradient.m`         | Computes the gradient of the objective |
| `compute_objective.m`        | Computes the objective function value |
| `compute_objective_vectorized.m` | Vectorized version of the objective |
| `project_onto_constraints.m` | Projects solution onto constraint set |
| `total_variation.m`          | Computes the total variation regularizer |
| `prox_tv_iterative.m`        | Proximal operator for TV via iteration |
| `frank_wolfe_method.m`       | (Optional) Implementation of the Frank-Wolfe method |
| `denoising_gui.m`            | Simple GUI to visualize original vs. restored image |

---

##  Test Images

- `cameraman.jpg` – Classic benchmark grayscale image  
- `fata.jpg` – Real image used to test algorithm performance under realistic noise

---

##  Notes

- The optimization problem is **constrained**, and in some methods, projection is used to ensure the solution remains within bounds (e.g., pixel values between 0 and 255).
- The code is modular and easy to extend for other noise models or regularizers (e.g., L1, Huber).

---

##  Author

**Mădălina Ioana Palade**  
Faculty of Automatic Control and Computers  
Bucharest, Romania

---

##  License

This project was developed for academic purposes. If you use or adapt the code, please cite the author or give credit in your project.

