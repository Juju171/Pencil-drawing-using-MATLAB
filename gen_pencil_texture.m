function T = gen_pencil_texture(img, H, J)
    % H = real pencil texture
    % J = tone map
    % T = pencil texture map

    [height, width] = size(img); % Image dimensions

    %% Conjugate gradient
    % Regularization parameter
    lamda = 0.2;

    % Adjust H (real pencil texture) and J (tone map) to corresponding size
    H_resize = im2double(imresize(H, [height, width], 'bicubic')); % Resize H
    H_reshape = reshape(H_resize, [], 1); % Reshape to column vector
    
    J_resize = im2double(imresize(J, [height, width], 'bicubic')); % Resize J
    J_reshape = reshape(J_resize, [], 1); % Reshape to column vector

    epsilon = 1e-6; % To avoid having log(0)
    log_H = log(H_reshape + epsilon);
    log_J = log(J_reshape + epsilon);

    % Sparse matrix initialization for the conjugate gradient method
    sparse_matrix = spdiags(log_H, 0, height * width, height * width); % Diagonal matrix
    e = ones(height * width, 1);
    ee = [-e, e];
    diags_x = [0, height * width];
    diags_y = [0, 1];
    
    dx = spdiags(ee, diags_x, height * width, height * width);
    dy = spdiags(ee, diags_y, height * width, height * width);

    % Matrix A and b to solve Ax = b
    A = lamda * ((dx * dx') + (dy * dy') ) + sparse_matrix' * sparse_matrix;
    b = sparse_matrix' * log_J;

    % Conjugate gradient
    beta = pcg(A, b, 1e-7,100);

    % Reshape result
    beta_reshaped = reshape(beta, [height, width]);

    % Pencil texture map T = H^beta
    T = H_resize .^ beta_reshaped; % Element by element

    return;
end