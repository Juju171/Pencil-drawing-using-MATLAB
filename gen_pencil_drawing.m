function R = gen_pencil_drawing(img, kernel_size, stroke_width, num_of_directions, smooth_kernel, ...
    w_group, pencil_texture, stroke_darkness, tone_darkness)

    % Conversion
    if length(size(img)) == 3 % RGB image
        img_yuv = rgb2yuv(img); % Convert RGB image to YUV color space
        im = img_yuv(:,:,1); % Extract the Y (luminance) component
    elseif length(size(img)) == 2 % Grayscale image
        im = img;
    end

    %% Stroke map
    S = gen_stroke_map(im, kernel_size, stroke_width, num_of_directions, smooth_kernel);
    S = S .^ stroke_darkness;

    %% Tone map
    J = gen_tone_map(im, w_group);

    %% Pencil texture map
    T = gen_pencil_texture(im, pencil_texture, J);
    T = T .^ tone_darkness;

    %% Final Y channel
    R = S .* T;

    if length(size(img)) == 3 % RGB image
        img_yuv(:,:,1) = R;
        R = yuv2rgb(img_yuv); % Convert YUV to RGB
        R = imadjust(R, [0, 1], [0, 1]); % Adjust intensity
        return;
    elseif length(size(img)) == 2 % Grayscale image
        R = imadjust(R, [0, 1], [0, 1]); % Adjust intensity
        return;
    end
end