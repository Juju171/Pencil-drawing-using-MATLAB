function yuv = rgb2yuv(rgb)
    % Make sure the image is in the range [0, 1]
    if max(rgb(:)) > 1
        rgb = double(rgb) / 255; % Normalize if necessary
    end

    % Transform matrix
    transformation_matrix = [0.299, 0.587, 0.114;
                             -0.14713, -0.28886, 0.436;
                             0.615, -0.51499, -0.10001];

    % Transform
    yuv = reshape((transformation_matrix * reshape(rgb, [], 3)')', size(rgb, 1), size(rgb, 2), 3);
end