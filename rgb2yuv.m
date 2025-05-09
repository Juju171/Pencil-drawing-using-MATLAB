function yuv = rgb2yuv(img)
    % Make sure the image is in the range [0, 1]
    if max(img(:)) > 1
        img = double(img) / 255; % Normalize if necessary
    end

    % Transform matrix
    transformation_matrix = [0.299, 0.587, 0.114;
                             -0.14713, -0.28886, 0.436;
                             0.615, -0.51499, -0.10001];

    % Transform
    yuv = reshape((transformation_matrix * reshape(img, [], 3)')', size(img, 1), size(img, 2), 3);
end