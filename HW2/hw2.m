% EE 440
% HW 2
% Luke Jiang
% 13/10/2018

clear all; close all;

% 1. generate histogram and CDF of one of the three bands of image 2_1
% -read the image, chose the 3rd band
lena = imread('2_1.bmp');
X3 = lena(:,:,3);
% -traverse X3 and keep track of the frequency of each gray level
graylevels = zeros(256, 1);
for i = 1:512
    for j = 1:512
        graylevels(X3(i, j)+1) = graylevels(X3(i, j)+1) + 1;
    end
end
% -plot the histogram
figure;
subplot(2, 1, 1);
plot(0:255, graylevels);
    xlim([0 255]);
    xlabel('gray level');
    ylabel('number of pixels');
    title('histogram for the third band of image 2-1');
% -traverse graylevels to get accumulative distribution data        
graylevel_cul = graylevels;
sum = 0;
for i = 1:256
    sum = sum + graylevel_cul(i);
    graylevel_cul(i) = sum;
end
% -normalize the dataset so that the maximum corresponds to 1
graylevel_cul = graylevel_cul / max(graylevel_cul);
% -plot the CDF
subplot(2, 1, 2);
plot(0:255, graylevel_cul);
    xlim([0 255]);
    xlabel('gray level');
    ylabel('cumulative of pixel number');
    title('CDF for the third band of image 2-1');
close;


% 2. display R,G,B and H,S,V images of 2_2.bmp
% -read the image and convert to HSV
X_rgb = imread('2_2.bmp', 'bmp');
X_hsv = rgb2hsv(X_rgb);
% -display R,G,B images
R = X_rgb(:,:,1);
G = X_rgb(:,:,2);
B = X_rgb(:,:,3);
figure; imshow(R);
figure; imshow(G);
figure; imshow(B);
% -display H,S,V images
H = X_hsv(:,:,1);
S = X_hsv(:,:,2);
V = X_hsv(:,:,3);
figure; imshow(H);
figure; imshow(S);
figure; imshow(V);

% 3. calculate the negative of 2_1.bmp
% -storage for the negative in unit8
lena_neg = uint8(zeros(512, 512, 3));
% -traverse all pixels
% -since 2_1.bmp is in uint8, 2^8 = 256
for i = 1:3
    for j = 1:512
        for k = 1:512
            lena_neg(k, j, i) = (256 - lena(k, j, i)) - 1;
        end
    end
end

figure; imshow(lena_neg);
        