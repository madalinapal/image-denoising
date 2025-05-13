% Deschide fișierul de imagini
fid_images = fopen('mnist-master/train-images-idx3-ubyte', 'rb');
if fid_images == -1
    error('Nu s-a putut deschide fișierul de imagini.');
end

% Citește header-ul fișierului de imagini
fread(fid_images, 1, 'int32', 0, 'ieee-be');  % ignoră magic number
num_images = fread(fid_images, 1, 'int32', 0, 'ieee-be');
num_rows = fread(fid_images, 1, 'int32', 0, 'ieee-be');
num_cols = fread(fid_images, 1, 'int32', 0, 'ieee-be');

% Deschide fișierul de etichete
fid_labels = fopen('mnist-master/train-labels-idx1-ubyte', 'rb');
if fid_labels == -1
    error('Nu s-a putut deschide fișierul de etichete.');
end

% Citește header-ul fișierului de etichete
fread(fid_labels, 1, 'int32', 0, 'ieee-be');  % ignoră magic number
num_labels = fread(fid_labels, 1, 'int32', 0, 'ieee-be');

% Citește prima imagine
image = fread(fid_images, num_rows * num_cols, 'uint8');
image = reshape(image, [num_cols, num_rows])';  % transpus pentru orientare corectă

% Citește primul label
label = fread(fid_labels, 1, 'uint8');

% Afișează imaginea și label-ul
imshow(image, []);
title(['Label: ', num2str(label)]);

% Închide fișierele
fclose(fid_images);
fclose(fid_labels);
