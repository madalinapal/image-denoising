% clear; clc; close all;
% 
% % === INCARCARE IMAGINE ===
% Im_noisy = im2double(imread('archive/00019.png'));
% if size(Im_noisy, 3) == 3
%     Im_noisy = rgb2gray(Im_noisy);
% end
% 
% % % === ADAUGARE ZGOMOT GAUSSIAN ===
% % sigma = 0.05;
% % noise = sigma * randn(size(Im));
% % Im_noisy = Im + noise;
% % Im_noisy = min(max(Im_noisy, 0), 1);
% 
% % === PARAMETRI ALGORITM ===
% beta = 0.1;
% epsilon = 1e-3;
% max_iter = 1000;
% tol = 1e-8;
% 
% % === PARAMETRU ADMM ===
% rho = 40;
% 
% % === RULARE METODE ===
% [X_admm, obj_admm] = admm_denoising_tv(Im_noisy, beta, epsilon, rho, max_iter, tol);
% [X_proj, obj_proj, grad_proj, step_proj, time_proj] = projected_gradient_method(Im_noisy, beta, max_iter, epsilon, tol);
% [X_fmincon, obj_fmincon, grad_fmincon, step_fmincon, time_fmincon, exitflag, output] = solve_fmincon(Im_noisy, beta, epsilon, max_iter);
% disp(output);
% disp(exitflag);
% 
% psnr_admm = psnr(X_admm, Im_noisy);
% psnr_pg = psnr(X_proj, Im_noisy);
% psnr_fmincon = psnr(X_fmincon, Im_noisy);
% 
% ssim_pg = ssim(X_proj, Im_noisy);
% ssim_admm = ssim(X_admm, Im_noisy);
% ssim_fmincon = ssim(X_fmincon, Im_noisy);
% 
% methods = {'PG', 'ADMM', 'fmincon', 'CVX'};
% psnr_vals = [psnr_pg, psnr_admm, psnr_fmincon];
% ssim_vals = [ssim_pg, ssim_admm, ssim_fmincon];
% 
% figure;
% subplot(1,2,1);
% bar(psnr_vals);
% set(gca, 'XTickLabel', methods);
% ylabel('PSNR (dB)');
% title('Comparatie PSNR');
% grid on;
% 
% subplot(1,2,2);
% bar(ssim_vals);
% set(gca, 'XTickLabel', methods);
% ylabel('SSIM');
% title('Comparatie SSIM');
% grid on;
% 
% % === FIGURA 1: IMAGINI ===
% figure('Position', [100, 100, 1600, 400]);
% 
% subplot(1,4,1);
% imshow(Im_noisy);
% title('Imagine zgomotoasa');
% 
% subplot(1,4,2);
% imshow(X_proj);
% title('Denoised - Gradient Proiectat');
% 
% subplot(1,4,3);
% imshow(X_admm);
% title('Denoised - ADMM');
% 
% subplot(1,4,4);
% imshow(X_fmincon);
% title('Denoised - fmincon');
% 
% % === FIGURA 2: FUNCTIA OBIECTIV (unde ADMM nu are gradient/step) ===
% figure('Position', [150, 150, 800, 600]);
% 
% subplot(3,1,1);
% plot(1:length(obj_admm), obj_admm, 'r-', 'LineWidth', 2); hold on;
% plot(1:length(obj_proj), obj_proj, 'b-', 'LineWidth', 2);
% plot(1:length(obj_fmincon), obj_fmincon, 'g-', 'LineWidth', 2);
% legend('ADMM', 'Gradient Proiectat', 'fmincon');
% ylabel('Functia obiectiv');
% title('Evolutia functiei obiectiv');
% grid on;
% 
% subplot(3,1,2);
% plot(1:length(grad_proj), grad_proj, 'b-', 'LineWidth', 2); hold on;
% plot(1:length(grad_fmincon), grad_fmincon, 'g-', 'LineWidth', 2);
% legend('Gradient Proiectat', 'fmincon');
% ylabel('Norma gradientului');
% grid on;
% 
% subplot(3,1,3);
% plot(1:length(step_proj), step_proj, 'b-', 'LineWidth', 2); hold on;
% plot(1:length(step_fmincon), step_fmincon, 'g-', 'LineWidth', 2);
% legend('Gradient Proiectat', 'fmincon');
% ylabel('Norma pasului');
% xlabel('Iteratii');
% grid on;
% 
% % === FIGURA 3: OBIECTIV ÎN FUNCȚIE DE TIMP ===
% % (ADMM nu returnează timp sau gradient — deci ignorăm aici sau adăugăm opțional)
% figure('Position', [200, 200, 800, 400]);
% plot(time_proj, grad_proj, 'b-', 'LineWidth', 2); hold on;
% plot(time_fmincon, grad_fmincon, 'g-', 'LineWidth', 2);
% legend('Gradient Proiectat', 'fmincon');
% xlabel('Timp [s]');
% ylabel('Norma gradientului');
% title('Norma gradientului în functie de timp');
% grid on;
% 

denoising_gui()