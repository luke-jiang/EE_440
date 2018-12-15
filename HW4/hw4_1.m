% EE 440
% HW 4 Part 1
% Luke Jiang
% 23/10/2018

clear all; close all;

% -read the original image and display it
img = imread('src/4_1.bmp');
figure(1); subplot(2, 2, 1);
    imshow(img);
    title('original image');

% -generate the noised image
img_n = img;
for i = 1:512
    for j = 1:512
        if (rand() < 0.15) % 15% probability of chosen as noise pixel
            black = randi([0, 1]); % 50% probability of dark/white noise
            if (black) img_n(i,j,:) = [255, 255, 255];
            else img_n(i,j,:) = [0, 0, 0];
            end
        end
    end
end

% -display and save the noisy image
figure(1); subplot(2, 2, 2);
    imshow(img_n);
    title('noisy image');
imwrite(img_n, 'src/4_1_noisy.bmp');

% -using a LPF to reduce noise and display the result
LPF = (1/9) * ones(3, 3);
img_LPF = uint8(zeros(514, 514, 3));
img_LPF(:,:,1) = conv2(img_n(:,:,1), LPF);
img_LPF(:,:,2) = conv2(img_n(:,:,2), LPF);
img_LPF(:,:,3) = conv2(img_n(:,:,3), LPF);
figure(1); subplot(2, 2, 3);
    imshow(img_LPF);
    title('apply Low Pass Filter to noisy img');
imwrite(img_LPF, 'src/4_1_LPF.bmp');

% -using a MF to reduce noise and display the result
img_n1 = img_n(:,:,3);
img_MF = uint8(zeros(512, 512, 3));
A_ = uint8(zeros(3, 3));  % preallocate space(3x3 window) for calculating median
for i = 1:510
    for j = 1:510
        A_ = img_n1(i:i+2, j:j+2);
        img_MF(i,j,1) = median(A_(:));
    end
end
img_MF(:,:,2) = img_MF(:,:,1);
img_MF(:,:,3) = img_MF(:,:,1);
figure(1); subplot(2, 2, 4);
    imshow(img_MF);
    title('apply Median Filter to noisy img');
imwrite(img_MF, 'src/4_1_MF.bmp');
