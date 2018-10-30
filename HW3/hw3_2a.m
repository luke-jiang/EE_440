% EE 440
% HW 3 Part 2(1)
% Luke Jiang
% 16/10/2018

% Using a) Linear stretching, b )Histogram equalization, c) Histogram
% specification to process 3_2.jpg

clear all; close all;

% -parameters for drawing
IM2_RES = 2;
IM2_HIST = 3;
IM2_CDF = 4;
% -read and display the orignal image
im2 = imread('3_2.jpg');
figure(IM2_RES); subplot(2, 2, 1);
    imshow(im2);
    title('original 3\_2.jpg');
% -convert to HSV and get the histogram of the V band
im2_hsv = rgb2hsv(im2);
V2 = im2_hsv(:,:,3);
V2_X = size(V2, 1); 
V2_Y = size(V2, 2);
figure(IM2_HIST); subplot(2, 2, 1);
    imhist(V2);
    title('histogram for V band of original 3\_2.jpg');
% -get CDF and plot it
[binLocations, cdf2] = getCDF(V2, IM2_CDF, 2, 2, 1, 'CDF of original 3\_2.jpg');

% a) Linear Stretching:
% -from hist see that V mostly falls in [0, 0.6] => 5/3
% -produce stretched V as V_str and display its histogram
V2_str = V2 * 5/3;
figure(IM2_HIST); subplot(2, 2, 2);
    imhist(V2_str);
    title('histogram for V band of stretched 3\_2.jpg');
% -get equalized CDF and display
getCDF(V2_str, IM2_CDF, 2, 2, 2, 'CDF of stretched 3\_2.jpg');
% -get result image, display and save
VReplaceDisplaySave(im2_hsv, V2_str, IM2_RES, 2, 2, 2, ...
'linear stretched 3\_2.jpg', 'im2_stretched.jpg');

% b) Histogram Equalization:
% -calculate equalized V band
V2_eq = cdf2(round(V2 / 0.0039) + 1);
% -display the equalized histogram
figure(IM2_HIST); subplot(2, 2, 3);
    imhist(V2_eq);
    title('histogram for V band of equalized 3\_2.jpg');
% -get equalized CDF and display
getCDF(V2_eq, IM2_CDF, 2, 2, 3, 'CDF of equalized 3\_2.jpg');
% -get result image, display and save
VReplaceDisplaySave(im2_hsv, V2_eq, IM2_RES, 2, 2, 3, ...
'Histogram equalized 3\_2.jpg', 'im2_equalized.jpg');

% c) Histogram Specification:
% -use a specified normal distribution (sp) as the target histogram
sp2 = normpdf(0:0.0039:1, 1, 0.39)';
sp2 = sp2(1:end-1);
cdf_sp2 = cumsum(cdf2);
cdf_sp2 = cdf_sp2 / max(cdf_sp2);
% -for each pixel, get the index of the sp value that is smaller and
% most close to the cdf of this pixel.
V2_sp = zeros(V2_X, V2_Y);
for i = 1:V2_X
    for j = 1:V2_Y
        cdf_ij = cdf2(round(V2(i, j) / 0.0039) + 1);
        index = 1;
        while (cdf_sp2(index) < cdf_ij)
            index = index + 1;
        end
        V2_sp(i, j) = binLocations(index);
    end
end
% -display the specified histogram
figure(IM2_HIST); subplot(2, 2, 4);
    imhist(V2_sp);
    title('histogram for V band of specified 3\_2.jpg');
% -get specified CDF and display
getCDF(V2_sp, IM2_CDF, 2, 2, 4, 'CDF of specified 3\_2.jpg');
% -get result image, display and save
VReplaceDisplaySave(im2_hsv, V2_sp, IM2_RES, 2, 2, 4, ...
'Histogram specified 3\_2.jpg', 'im2_specified.jpg');

