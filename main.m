clear all; close all; clc;
[A, map] = imread('patch2.jpg');
s = im2double(rgb2gray(A)); % reading image
% imshow(s); % check if the image has been read correctly
[M, N] = size(s); % M = num of rows, N = num of cols

sigma = 17; % 9;
R = 5;

% subdivide the image into overlapping gaussian-windowed patches
% 50x50 patch
% overlapping patches centered at each 14 pixels
% patches = {};
allWaves = cell(M, N);

window = getGaussian2D(M, N, sigma);
waves = getWaves(s, window, R);


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
%         % remappedWaves = remap(allWaves, R);
%         
%         % Aligh Remapped Waves:
%         
%         % patches{i, j} = patch;
%     end
% end
