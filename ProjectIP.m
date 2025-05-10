clc; clear; close all;

%% Imports
% Image
img_filename = 'MAD_Architecture2'; % Only change this value (names in the inputs folder)
ex_img = imread(['./inputs/', img_filename, '.jpg']);
[height, width] = size(ex_img); % Image dimensions

% Pencil
pencil_nbr = '4'; % Only change this value (0 to 5 (1 is bad))
pencil_filename = ['pencil', pencil_nbr]; 
pencil_texture = imread(['./pencils/', pencil_filename, '.jpg']);

%% Parameters
kernel_size = round(height/100);     % size of the line segment kernel (usually 1/50 of the height of the original image)
stroke_width = 3;                   % thickness of the strokes in the Stroke Map (1, 2, 3)
num_of_directions = 8;              % number of stroke directions in the Stroke Map
smooth_kernel = "gauss";            % how the image is smoothed (Gaussian Kernel - "gauss", Median Filter - "median")
w_group = 0;                        % 3 possible weight groups (0, 1, 2) for the histogram distribution, according to the paper (brighter to darker)
stroke_darkness = 1;                % 1 is the same, up is darker
tone_darkness = 1;                  % 1 is the same, up is darker

%% Conversion
if length(size(ex_img)) == 3 % RGB image
    img_yuv = rgb2yuv(ex_img); % Convert RGB image to YUV color space
    img = img_yuv(:,:,1); % Extract the Y (luminance) component
elseif length(size(ex_img)) == 2 % Grayscale image
    img = ex_img;
end

pencil_texture = rgb2gray(pencil_texture); % Convert to grayscale

%% Stroke map
% ex_img_stroke_map = gen_stroke_map(img, kernel_size, stroke_width, num_of_directions, smooth_kernel);
% 
% % Results
% figure;
% subplot(1,2,1); imshow(ex_img); title('Original image');
% axis off;
% subplot(1,2,2); imshow(ex_img_stroke_map); title('Stroke Map');
% axis off;
% sgtitle('Stroke map generation')

%% Tone map
% % Different w_group values comparison
% figure;
% subplot(2,2,1); imshow(img); title('Original gray image'); axis off;
% for i = 0:2
%     ex_img_tone_map_i = gen_tone_map(img, i);
%     subplot(2,2,i+2); imshow(ex_img_tone_map_i); title(['Tone map group ', num2str(i+1)]); axis off;
% end
% sgtitle('Tone map generation: w group value comparison');


%% Pencil texture map
% ex_img_tone_map_0 = gen_tone_map(img, 0);
% ex_img_tex_map = gen_pencil_texture(img, pencil_texture, ex_img_tone_map_0);
% 
% % Results
% figure;
% subplot(1,2,1); imshow(ex_img); title('Original image');
% axis off;
% subplot(1,2,2); imshow(ex_img_tex_map); title('Finale texture map');
% axis off;
% sgtitle('Pencil texture map generation')


%% Combined result
ex_im_pen = gen_pencil_drawing(ex_img, kernel_size , stroke_width, num_of_directions, smooth_kernel,... %rgb, 
    w_group, pencil_texture, stroke_darkness, tone_darkness);

% Results
figure;
subplot(1,2,1); imshow(ex_img); title('Original image');
axis off;
subplot(1,2,2); imshow(ex_im_pen); title('Pencil drawing');
axis off;
hold on
sgtitle('Pencil drawing generation')

%% Image save
% % Define output directory path
% output_dir = fullfile('outputs', img_filename);
% % Create the directory if it does not exist
% if ~exist(output_dir, 'dir')
%     mkdir(output_dir);
% end
% % Save image as PNG inside the output directory
% imwrite(ex_im_pen, fullfile(output_dir, [img_filename, '_', pencil_filename, '.png']));

%% Comparison
% % Different kernel_size values comparison
% mult = 20; % depending on size of the input image, it may be needed to decrease the mult (to 10 for example)
% figure;
% for i = 0:3
%     ex_img_stroke_map_i = gen_pencil_drawing(ex_img, round(height / ((i + 1) * mult)), stroke_width, num_of_directions, smooth_kernel,... %rgb,
%     w_group, pencil_texture, stroke_darkness, tone_darkness);
%     subplot(2,2,i+1); imshow(ex_img_stroke_map_i); title(['Kernel size value = height/', num2str((i + 1) * mult)]); axis off;
% 
%     % % Save results
%     % filename = fullfile('outputs', ['stroke_map_kernel_size_', num2str(((i + 1) * mult)), '.png']);
%     % imwrite(ex_img_stroke_map_i, filename);
% end
% sgtitle('Stroke map generation: kernel size value comparison');

% % Different stroke_width values comparison
% figure;
% subplot(2,2,1); imshow(ex_img); title('Original gray image'); axis off;
% for i = 0:2
%     ex_img_stroke_map_i = gen_pencil_drawing(ex_img, kernel_size, i, num_of_directions, smooth_kernel,... %rgb,
%     w_group, pencil_texture, stroke_darkness, tone_darkness);
%     subplot(2,2,i+2); imshow(ex_img_stroke_map_i); title(['Stroke width value = ', num2str(i+1)]); axis off;
% 
%     % % Save results
%     % filename = fullfile('outputs', ['stroke_map_stroke_width_', num2str(i+1), '.png']);
%     % imwrite(ex_img_stroke_map_i, filename);
% end
% sgtitle('Stroke map generation: stroke width value comparison');

% % Different num_of_directions values comparison
% figure;
% for i = 0:3
%     ex_img_stroke_map_i = gen_pencil_drawing(ex_img, kernel_size, stroke_width, (i+1)*4, smooth_kernel,... %rgb,
%     w_group, pencil_texture, stroke_darkness, tone_darkness);
%     subplot(2,2,i+1); imshow(ex_img_stroke_map_i); title(['Number of direction value = ', num2str((i+1)*4)]); axis off;
% 
%     % % Save results
%     % filename = fullfile('outputs', ['stroke_map_num_of_directions_', num2str((i+1)*4), '.png']);
%     % imwrite(ex_img_stroke_map_i, filename);
% end
% sgtitle('Stroke map generation: number of directions value comparison');

% % Different w_group values comparison
% figure;
% subplot(2,2,1); imshow(ex_img); title('Original image'); axis off;
% for i = 0:2
%     ex_im_pen_i = gen_pencil_drawing(ex_img, kernel_size , stroke_width,num_of_directions, smooth_kernel,... %rgb,
%     i, pencil_texture, stroke_darkness, tone_darkness);
%     subplot(2,2,i+2); imshow(ex_im_pen_i); title(['Tone map group = ', num2str(i+1)]); axis off;
% end
% sgtitle('Pencil drawing generation: w group value comparison');
