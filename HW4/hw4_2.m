% EE 440
% HW 4 Part 1
% Luke Jiang
% 23/10/2018

clear all; close all;

% -read and display the original image
img = imread('4_2.bmp');
figure; subplot(1, 2, 1);
    imshow(img);
    title('original image');
% -create a high boost filter
HBF = [-1 -1 -1; -1 9.7 -1; -1 -1 -1];
% -convolve the HBF with the image to produce the result
res = uint8(zeros(482, 642, 3));
res(:,:,1) = conv2(img(:,:,1), HBF);
res(:,:,2) = conv2(img(:,:,2), HBF);
res(:,:,3) = conv2(img(:,:,3), HBF);
% -display and save the result
subplot(1, 2, 2);
    imshow(res);
    title('sharpened image using a HBF');
imwrite(img_n, '4_2_HBF.bmp');
