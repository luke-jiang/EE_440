
% EE 440
% HW 5
% Luke Jiang
% 30/10/2018


clear all; close all;
% read the image
img = double(imread('5_1.bmp'));
figure(1); subplot(2, 2, 1);
    imshow(img/256);
    title('original image');
% perform FFT and display the resultant magnitude and phase
F = fftshift(fft2(img));
Fn = log(abs(F));

F_magn = mat2gray(log(abs(F)));
F_phas = angle(F);
subplot(2, 2, 2);
    imshow(F_magn);
    title('magnitude of original img');
subplot(2, 2, 3);
    imshow(F_phas);
    title('phase of original image');
% eliminate noise points on the magnitude of the image
F_m2 = abs(F);
F_m2(125:130, 125:130, :) = 0;
F_m2(125:130, 383:386, :) = 0;
F_m2(383:386, 125:130, :) = 0;
F_m2(383:386, 383:386, :) = 0;
% perform inverse FFT and display the result
F_c = F_m2 .* exp(1i * F_phas);
img2 = ifft2(fftshift(F_c));
figure(3);
    imshow(abs(img2)/256);
    title('denoised image');
imwrite(abs(img2)/256, '5_1_denoised.bmp');
