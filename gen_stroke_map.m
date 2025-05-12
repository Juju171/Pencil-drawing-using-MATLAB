function S = gen_stroke_map(img, kernel_size, stroke_width, n_directions, smooth_kernel)

    [height, width] = size(img); % Image dimensions

    %% Classification: smoothing + gradients calculation (Sobel)
    % Smoothing
    if smooth_kernel == "gauss"
        img = conv2(img, fspecial('gaussian'), 'same'); % Gaussian smoothing
    elseif smooth_kernel == "median"
        img = medfilt2(img); % Default median smoothing
    end

    % Sobel operators
    sobel_x = -fspecial('sobel'); % Horizontal Sobel operator
    sobel_y = sobel_x'; % Vertical Sobel operator

    % Filter
    grad_x = conv2(img, sobel_x, 'same'); % Horizontal Sobel filter
    grad_y = conv2(img, sobel_y, 'same'); % Vertical Sobel filter

    % Gradient map (G)
    G = sqrt(grad_x.^2 + grad_y.^2);

    % Kernel definition: square matrix full of 0s and middle horizontal line filled in with 1s
    initial_kernel = zeros(kernel_size * 2 + 1, kernel_size * 2 + 1);
    initial_kernel(kernel_size + 1, :) = 1; % Horizontal line of 1s

    % Response map for each direction using the convolution operation
    response_map = zeros(height, width, n_directions); % Response map initialization

    for d = 1:n_directions
        ker = imrotate(initial_kernel, (d * 180) / n_directions, 'bilinear', 'crop');
        response_map(:, :, d) = conv2(G, ker, 'same'); % Convolution
    end

    % Classification: selecting the maximum value among the responses in all directions
    [~, max_direction] = max(response_map, [], 3);
    
    C = zeros(size(response_map)); % Classification map (C) initialization
    for d = 1:n_directions
        C(:, :, d) = G .* (max_direction == d);
    end

    %% Line Shaping: pencil stroke map (S) generation
    % Width of the stroke
    for w = 0:stroke_width-1
        if (kernel_size + 1 - w) >= 1
            initial_kernel(kernel_size + 1 - w, :) = 1;
        end
        if (kernel_size + 1 + w) <= (kernel_size * 2 + 1)
            initial_kernel(kernel_size + 1 + w, :) = 1;
        end
    end

    % Calculation of S'
    S_dir = zeros(size(C)); % S' initialization

    for d = 1:n_directions
        ker = imrotate(initial_kernel, (d * 180) / n_directions, 'bilinear', 'crop');
        S_dir(:, :, d) = conv2(C(:, :, d), ker, 'same'); % Convolution

        % % Show intermediate results
        % S_dir_show = rescale(S_dir(:, :, d)); % Only current direction
        % figure; imshow(S_dir_show); axis off;
        % title(['Direction ', num2str(d)]);
        % 
        % % Save intermediate results
        % filename = fullfile('outputs', ['stroke_map_direction_', num2str(d), '.png']);
        % imwrite(S_dir_show, filename);
    end
    S = sum(S_dir, 3); % Sum over 3 directions

    S = rescale(S); % Normalization of S: values are in [0,1]

    S = 1 - S; % Inversion

    % % Save final result
    % filename = fullfile('outputs', 'stroke_map.png');
    % imwrite(S, filename);
end