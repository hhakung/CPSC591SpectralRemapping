clear all; close all; clc;
[A, map] = imread('patch2.jpg');
s = im2double(rgb2gray(A)); % reading image
% imshow(s); % check if the image has been read correctly
[M, N] = size(s); % M = num of rows, N = num of cols

sigma = 15; % 9;
R = 5;

% subdivide the image into overlapping gaussian-windowed patches
% 50x50 patch
% overlapping patches centered at each 14 pixels
% patches = {};
% allWaves = cell(M, N);

allWaves = cell(1, 1);
window = getGaussian2D(M, N, sigma);
allWaves{1, 1} = getWaves(s, window, R);
remappedWaves = remap(allWaves, R);

WmnRemapped = zeros(M, N);
for i = 1:size(remappedWaves{1, 1}, 1)
    w = zeros(M, N);
    for m = 1:M
        for n = 1:N
            w(m, n) = remappedWaves{1, 1}(i, 1) * exp(2 * pi * sqrt(-1) * (remappedWaves{1, 1}(i, 2) * m + remappedWaves{1, 1}(i, 3) * n + remappedWaves{1, 1}(i, 4)));
        end
    end
    WmnRemapped = WmnRemapped + fftshift(fft2(w.*window));
end

figure, imagesc(log10(abs(WmnRemapped).^2));
title('Sum of All the Remapped Non-representable Waves');

figure, imshow(abs(ifft2(ifftshift(WmnRemapped))));
title('Image of Remapped Non-representable Waves');

% for i = 26:26:M-25
%     for j = 26:26:N-25
%         patch = s(i-25:i+25, j-25:j+25);
%         % imshow(patch);
%         window = getGaussian2D(size(patch, 1), size(patch, 2), sigma);
%         
%         % Detecting Local Waves: get waves for this patch and store in allWaves
%         allWaves{i, j} = getWaves(patch, window, R);
%         
%         % Remap Waves:
%         remappedWaves = remap(allWaves, R);
%         
%         % Aligh Remapped Waves:
%         
%         % patches{i, j} = patch;
%     end
% end
