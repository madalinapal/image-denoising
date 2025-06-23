function denoising_gui()

    % Creează interfața grafică
    fig = uifigure('Name', 'Denoising Interface', 'Position', [100, 100, 800, 600]);
    
    % Calculăm poziția pentru butonul centrat în partea de jos
    button_width = 200;
    button_height = 30;
    button_x = (fig.Position(3) - button_width) / 2; % Centrarea butonului pe axa X
    button_y = 20; % Poziția verticală la 20px de jos
    loadButton = uibutton(fig, 'push', 'Text', 'Încărcați imaginea zgomotoasă', ...
                          'Position', [button_x, button_y, button_width, button_height], ...
                          'ButtonPushedFcn', @(btn, event) loadImage(fig, loadButton)); % Funcția callback
    
    % Axele pentru a vizualiza imaginile
    ax1 = axes(fig, 'Position', [0.1, 0.1, 0.2, 0.35]); % Imagine zgomotoasă
    ax2 = axes(fig, 'Position', [0.4, 0.1, 0.2, 0.35]); % Imagine denoised PG
    ax3 = axes(fig, 'Position', [0.7, 0.1, 0.2, 0.35]); % Imagine denoised ADMM
    ax4 = axes(fig, 'Position', [0.4, 0.5, 0.2, 0.35]); % Imagine denoised fmincon
    
    % Text pentru a arăta rezultatele PSNR și SSIM
    psnrText = uilabel(fig, 'Position', [300, 500, 400, 30], 'Text', 'PSNR & SSIM comparativ');
    psnrLabel = uilabel(fig, 'Position', [300, 460, 400, 30], 'Text', '');
    
    % Variabile globale pentru imagini
    global Im_noisy X_admm X_proj X_fmincon;
    
    % Funcția pentru încărcarea imaginii zgomotoase
    function loadImage(fig, loadButton)
        % Deschide dialogul pentru a selecta imaginea zgomotoasă
        [file, path] = uigetfile({'*.png'; '*.jpg'; '*.jpeg'; '*.bmp'}, 'Selectați imaginea zgomotoasă');
        if isequal(file, 0)
            return; % Dacă nu este selectată nicio imagine, ieși din funcție
        end
        
        % Încarcă imaginea zgomotoasă
        Im_noisy = im2double(imread(fullfile(path, file)));
        if size(Im_noisy, 3) == 3
            Im_noisy = rgb2gray(Im_noisy); % Convertește la grayscale dacă este necesar
        end
        
        % Afișează imaginea zgomotoasă
        imshow(Im_noisy, 'Parent', ax1);
        title(ax1, 'Imagine Zgomotoasă');
        
        % Rularea metodelor de denoising
        runDenoising();
        
        % Ascunde butonul după ce s-a încărcat imaginea
        set(loadButton, 'Visible', 'off'); % Ascunderea butonului
    end
    
    % Funcția pentru a rula metodele de denoising
    function runDenoising()
        % Parametrii pentru metodele de denoising
        beta = 0.1;
        epsilon = 1e-3;
        max_iter = 1000;
        tol = 1e-8;
        rho = 40;
        
        % Rularea celor trei metode
        [X_admm, ~] = admm_denoising_tv(Im_noisy, beta, epsilon, rho, max_iter, tol);
        [X_proj, ~, ~, ~, ~] = projected_gradient_method(Im_noisy, beta, max_iter, epsilon, tol);
        [X_fmincon, ~, ~, ~, ~, ~, ~] = solve_fmincon(Im_noisy, beta, epsilon, max_iter);
        
        % Afișarea imaginilor denoised
        imshow(X_proj, 'Parent', ax2);
        title(ax2, 'Denoised - Gradient Proiectat');
        
        imshow(X_admm, 'Parent', ax3);
        title(ax3, 'Denoised - ADMM');
        
        imshow(X_fmincon, 'Parent', ax4);
        title(ax4, 'Denoised - fmincon');
        
        % Calcul PSNR și SSIM pentru fiecare metodă
        psnr_admm = psnr(X_admm, Im_noisy);
        psnr_proj = psnr(X_proj, Im_noisy);
        psnr_fmincon = psnr(X_fmincon, Im_noisy);
        
        ssim_admm = ssim(X_admm, Im_noisy);
        ssim_proj = ssim(X_proj, Im_noisy);
        ssim_fmincon = ssim(X_fmincon, Im_noisy);
        
        % Compararea rezultatelor
        psnr_vals = [psnr_proj, psnr_admm, psnr_fmincon];
        ssim_vals = [ssim_proj, ssim_admm, ssim_fmincon];
        
        % Afisarea PSNR și SSIM
        psnr_str = sprintf('PSNR - PG: %.2f dB, ADMM: %.2f dB, fmincon: %.2f dB', psnr_proj, psnr_admm, psnr_fmincon);
        ssim_str = sprintf('SSIM - PG: %.4f, ADMM: %.4f, fmincon: %.4f', ssim_proj, ssim_admm, ssim_fmincon);
        
        psnrLabel.Text = strcat(psnr_str, '\n', ssim_str);
        
        % Crează feronuri separate pentru graficele PSNR și SSIM
        createFigures(psnr_vals, ssim_vals);
    end

    % Funcția pentru crearea feronurilor pentru PSNR și SSIM
    function createFigures(psnr_vals, ssim_vals)
        % Fereastră PSNR
        figure('Name', 'Comparatie PSNR');
        bar(psnr_vals);
        set(gca, 'XTickLabel', {'PG', 'ADMM', 'fmincon'});
        ylabel('PSNR (dB)');
        title('Comparatie PSNR');
        grid on;

        % Fereastră SSIM
        figure('Name', 'Comparatie SSIM');
        bar(ssim_vals);
        set(gca, 'XTickLabel', {'PG', 'ADMM', 'fmincon'});
        ylabel('SSIM');
        title('Comparatie SSIM');
        grid on;
    end
end
