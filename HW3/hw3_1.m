% EE 440
% HW 3 Part 1
% Luke Jiang
% 16/10/2018

% 3.1. Remove extra magenta content from 3_1.bmp to make the image look
% more natural.

clear all; close all;

% -read image 3_1
img = double(imread('3_1.bmp'));
figure(1);
subplot(1, 2, 1);
    imshow(img / 255);
    title('original 3\_1.bmp'); 
% -M255 is used for conversion between RGB and CMY
M255 = 255 * ones(202, 282, 3);
% -get the CMY image
img_cmy = M255 - img;
C = img_cmy(:,:,1);
M = img_cmy(:,:,2);
Y = img_cmy(:,:,3);
% -the input image is heavy in magneta, use Power-Law Transform with
% -gamma = 2.5 to create a weaker version of the magneta band
M_weaker = ((M/255).^ 2.5)*255;
% -replace the original magneta band with the weakened version
img_weaker = img_cmy;
img_weaker(:,:,2) = M_weaker;
% -convert back to RGB, display and save the result
img_weaker = M255 - img_weaker;
subplot(1, 2, 2);
    imshow(img_weaker / 255);
    title('modified 3\_1.bmp'); 
imwrite(img_weaker / 255, '3_1_modified.bmp');

    
