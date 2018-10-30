% EE 440
% HW 3 Part 2(b)
% Luke Jiang
% 16/10/2018

% Using a) Linear stretching, b )Histogram equalization, c) Histogram
% specification to process 3_3.jpg

clear all; close all;

% -parameters for drawing
IM3_RES = 5;
IM3_HIST = 6;
IM3_CDF = 7;
% -read and display the orignal image
im3 = imread('3_3.jpg');
figure(IM3_RES); subplot(2, 2, 1);
    imshow(im3);
    title('original 3\_3.jpg');
% -convert to HSV and get the histogram of the V band
im3_hsv = rgb2hsv(im3);
V3 = im3_hsv(:,:,3);
V3_X = size(V3, 1);
V3_Y = size(V3, 2);
figure(IM3_HIST); subplot(2, 2, 1);
    imhist(V3);
    title('histogram for V band of original 3\_3.jpg');
% get CDF and plot it:
[binLocations3, cdf3] = getCDF(V3, IM3_CDF, 2, 2, 1, 'CDF of original 3\_3.jpg');
cdf3 = [cdf3; 1];  % fix off-by-one error
binLocations3 = [binLocations3; 1];  % fix off-by-one error

% a) Linear Stretching:
% -from hist see that V mostly falls in [0, 0.6] => 5/3
% -produce stretched V as V_str and display its histogram
V3_str = V3 * 5/3;
figure(IM3_HIST); subplot(2, 2, 2);
    imhist(V3_str);
    title('histogram for V band of stretched 3\_3.jpg');
% -get equalized CDF and display
getCDF(V3_str, IM3_CDF, 2, 2, 2, 'CDF of stretched 3\_3.jpg');
% -get result image, display and save
VReplaceDisplaySave(im3_hsv, V3_str, IM3_RES, 2, 2, 2, ...
'linear stretched 3\_3.jpg', 'im3_stretched.jpg');

% b) Histogram Equalization:
% -calculate equalized V band
V3_eq = cdf3(round(V3 / 0.0039) + 1);
% -display the equalized histogram
figure(IM3_HIST); subplot(2, 2, 3);
    imhist(V3_eq);
    title('histogram for V band of equalized 3\_3.jpg');
% -get equalized CDF and display
getCDF(V3_eq, IM3_CDF, 2, 2, 3, 'CDF of equalized 3\_3.jpg');
% -get result image, display and save
VReplaceDisplaySave(im3_hsv, V3_eq, IM3_RES, 2, 2, 3, ...
'Histogram equalized 3\_3.jpg', 'im3_equalized.jpg');

% c) Histogram Specification:
% -use a specified normal distribution (sp) as the target histogram
sp3 = normpdf(0:0.0039:1, 1, 0.39)';
sp3 = sp3(1:end-1);
cdf_sp3 = cumsum(cdf3);
cdf_sp3 = cdf_sp3 / max(cdf_sp3);
% -for each pixel, get the index of the sp value that is smaller and
% most close to the cdf of this pixel.
V3_sp = zeros(240, 320);
for i = 1:240
    for j = 1:320
        cdf_ij = cdf3(round(V3(i, j) / 0.0039) + 1);
        index = 1;
        while (cdf_sp3(index) < cdf_ij)
            index = index + 1;
        end
        V3_sp(i, j) = binLocations3(index);
    end
end
% -display the specified histogram
figure(IM3_HIST); subplot(2, 2, 4);
    imhist(V3_sp);
    title('histogram for V band of specified 3\_3.jpg');
% -get specified CDF and display
getCDF(V3_sp, IM3_CDF, 2, 2, 4, 'CDF of specified 3\_3.jpg');
% -get result image, display and save
VReplaceDisplaySave(im3_hsv, V3_sp, IM3_RES, 2, 2, 4, ...
'Histogram specified 3\_3.jpg', 'im3_specified.jpg');
                
 