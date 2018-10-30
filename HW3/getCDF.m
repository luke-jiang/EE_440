% EE 440
% HW 3
% Luke Jiang
% 16/10/2018

% Helper function:
% For a given image, plot the CDF of the pixels in the image and return
% the CDF

% @param V: input image
% @param fignum, a, b, c: which figure, (a, b, c) are subplot inputs
% @param ttl: the title of the plot
% @return binLocations: binLocations returned by imhist
% @return cdf: computed CDF

function [binLocations, cdf] = getCDF(V, fignum, a, b, c, ttl)
    [counts_, binLocations_] = imhist(V);
    counts = counts_;
    binLocations = binLocations_;
    % -get normalized CDF
    cdf = cumsum(counts) / (size(V, 1) * size(V, 2));
    % -plot the CDF
    figure(fignum); subplot(a, b, c);
    plot(binLocations, cdf);
    title(ttl);
end