% EE 440
% HW 3
% Luke Jiang
% 16/10/2018

% Helper function:
% Given an HSV file and a V band, replace the original V band with the input
% V band, convert the image back to RGB and display, save, and return the
% image

% @param hsv: input image in HSV format
% @param V: input V band to replace V band in hsv
% @param fignum, a, b, c: which figure, (a, b, c) are subplot inputs
% @param ttl: the title of the plot
% @param filename: the filename of the saved image
% @return res: the resultant RGB image
function res = VReplaceDisplaySave(hsv, V, fignum, a, b, c, ttl, filename)
    res = hsv;
    res(:,:,3) = V;
    res = hsv2rgb(res);
    figure(fignum); subplot(a, b, c);
    imshow(res);
    title(ttl);
    imwrite(res, filename);
end