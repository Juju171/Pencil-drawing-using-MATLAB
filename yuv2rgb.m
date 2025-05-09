function rgb = yuv2rgb(yuv)
    % Inverse transform matrix
    transformation_matrix = [1, 0, 1.13983;
                             1, -0.39465, -0.58060;
                             1, 2.03211, 0];

    % Inverse transform
    rgb = reshape((transformation_matrix * reshape(yuv, [], 3)')', size(yuv, 1), size(yuv, 2), 3);
end