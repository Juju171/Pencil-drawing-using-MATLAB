function J = gen_tone_map(img, w_group)
    % w_group = 0; % Default value
    
    %% Model-based Tone Transfer 
    % Calculate the parameters and define weight groups
    w_mat = [11, 37, 52;
             29, 29, 42;
             2, 22, 76];
    w = w_mat(w_group + 1, :);

    % Parameters definition according to tone levels (values from paper)
    % Bright layer [171 - 255]
    sigma_bright = 9; 
    % Mild layer [86 - 170]
    u_mild_a = 105;
    u_mild_b = 225;  
    % Dark layer [0 - 85]
    mu_dark = 90; 
    sigma_dark = 11;
    
    % Desired histogram (p(v)) (target tone distribution)
    pixel_values = 256;
    p = zeros(1, pixel_values); % Initialization
    
    for v = 1:pixel_values
        p1 = (1 / sigma_bright) * exp(-(255 - (v - 1)) / sigma_bright); % Bright layer 
        if (u_mild_a <= (v - 1)) && ((v - 1) <= u_mild_b) % Mild layer
            p2 = 1 / (u_mild_b - u_mild_a);
        else
            p2 = 0;
        end
        p3 = (1 / sqrt(2 * pi * sigma_dark)) * exp(-((v - 1 - mu_dark)^2) / (2 * sigma_dark^2)); % Dark layer
        p(v) = w(1) * p1 + w(2) * p2 + w(3) * p3 * 0.1;
    end
    
    p = p / sum(p); % Normalize
    P = cumsum(p); % CDF of desired histogram
    
    % Original histogram
    h = imhist(img);
    h = h / sum(h); % Normalize
    H = cumsum(h); % CDF of original histogram
    
    % Histogram Matching
    lut = zeros(1, pixel_values); % Initialization
    for v = 1:pixel_values
        % Find closest value
        [~, argmin_dist] = min(abs(P - H(v)));
        lut(v) = argmin_dist - 1;
    end
    
    lut_normalized = lut / pixel_values;
    J = lut_normalized(1 + round(255 * img));
    
    % Smoothing
    J = imgaussfilt(J, sqrt(2)); % Smoothing
end