clc; clear; close all;

%% Imports
% Image
img_filename = 'test6_VUB'; % Only change this value (names in the inputs folder)
ex_img = imread(['./inputs/', img_filename, '.jpg']);
[height, width] = size(ex_img); % Image dimensions

%% Parameters
kernel_size = round(height/100);     % size of the line segment kernel (usually 1/50 of the height of the original image)
stroke_width = 3;                   % thickness of the strokes in the Stroke Map (1, 2, 3)
num_of_directions = 8;              % number of stroke directions in the Stroke Map
smooth_kernel = "gauss";            % how the image is smoothed (Gaussian Kernel - "gauss", Median Filter - "median")
w_group = 0;                        % 3 possible weight groups (0, 1, 2) for the histogram distribution, according to the paper (brighter to darker)
stroke_darkness = 1;                % 1 is the same, up is darker
tone_darkness = 1.5;                  % 1 is the same, up is darker

%% Conversion
if length(size(ex_img)) == 3 % RGB image
    img_yuv = rgb2yuv(ex_img); % Convert RGB image to YUV color space
    img = img_yuv(:,:,1); % Extract the Y (luminance) component
elseif length(size(ex_img)) == 2 % Grayscale image
    img = ex_img;
end

%% Different pencil saves
figure;
sgtitle('Pencil drawing generation')
for i=0:6
    pencil_nbr = num2str(i);
    pencil_filename = ['pencil', pencil_nbr]; 
    pencil_texture = imread(['./pencils/', pencil_filename, '.jpg']);
    pencil_texture = rgb2gray(pencil_texture); % Convert to grayscale

    ex_im_pen = gen_pencil_drawing(ex_img, kernel_size , stroke_width, num_of_directions, smooth_kernel,... %rgb, 
    w_group, pencil_texture, stroke_darkness, tone_darkness);

    % Results
    if i<6
        subplot(3,3,i+1); imshow(ex_im_pen); title(['Pencil drawing (pencil n°',num2str(i)]);
        axis off;
        hold on
    else
        subplot(3,3,i+2); imshow(ex_im_pen); title(['Pencil drawing (pencil n°',num2str(i), ')']);
        axis off;
        hold on
    end

    % Image save
    % Define output directory path
    output_dir = fullfile('outputs', img_filename);
    % Create the directory if it does not exist
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end
    % Save image as PNG inside the output directory
    imwrite(ex_im_pen, fullfile(output_dir, [img_filename, '_', pencil_filename, '.png']));

end
