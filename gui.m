function desen_cifra_gui()
    % Creează interfața grafică
    fig = figure('Name', 'Draw a number (0-9)', ...
                 'NumberTitle', 'off', ...
                 'Color', 'white', ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none', ...
                 'Position', [500 300 400 450]);

    % Zona de desen
    ax = axes('Parent', fig, ...
              'Position', [0.1 0.35 0.8 0.6]);
    axis(ax, [0 1 0 1]); % pătrat de 1x1
    set(ax, 'YDir', 'reverse'); % origine sus-stânga
    set(ax, 'xtick', [], 'ytick', []); % elimină axele
    box(ax, 'on'); % afișează chenarul
    hold(ax, 'on');
    title(ax, 'Draw a number using your mouse');

    % Buton "Șterge"
    uicontrol('Style', 'pushbutton', ...
              'String', 'Delete', ...
              'FontSize', 12, ...
              'Position', [50 30 100 40], ...
              'Callback', @(src, event) cla(ax));

    % Buton "Salvează"
    uicontrol('Style', 'pushbutton', ...
              'String', 'Save', ...
              'FontSize', 12, ...
              'Position', [250 30 100 40], ...
              'Callback', @(src, event) salveaza_desen(ax));

    % Activare funcție de desenare
    set(fig, 'WindowButtonDownFcn', @(src, event) start_desen(ax));
end

function start_desen(ax)
    % Începe desenul dacă s-a dat click stânga
    if strcmp(get(gcf, 'SelectionType'), 'normal')
        pt = get(ax, 'CurrentPoint');
        x = pt(1,1);
        y = pt(1,2);
        h = line('XData', x, 'YData', y, ...
                 'Color', 'k', 'LineWidth', 10, 'Parent', ax);
        set(gcf, 'WindowButtonMotionFcn', @(src, event) deseneaza(h, ax));
        set(gcf, 'WindowButtonUpFcn', @(src, event) stop_desen());
    end
end

function deseneaza(h, ax)
    pt = get(ax, 'CurrentPoint');
    x = pt(1,1);
    y = pt(1,2);
    xd = get(h, 'XData');
    yd = get(h, 'YData');
    set(h, 'XData', [xd x], 'YData', [yd y]);
end

function stop_desen()
    set(gcf, 'WindowButtonMotionFcn', '');
    set(gcf, 'WindowButtonUpFcn', '');
end

function salveaza_desen(ax)
    frame = getframe(ax);
    img = frame2im(frame);
    img_gray = rgb2gray(img);
    img_resized = imresize(img_gray, [28 28]);
    img_bw = imbinarize(img_resized);

    figure('Name', 'Imagine 28x28');
    imshow(img_bw);
    title('Imagine redimensionată 28x28');

    imwrite(img_bw, 'cifra_desenata.png');
    disp('Imagine salvată ca "cifra_desenata.png"');
end
