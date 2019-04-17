clear all; close all; clc;
image = im2double(rgb2gray(imread('warpedCheckerboard.jpg')));
image = image(50:74, 50:74);
R = 5;
sigma = 10;

result = mainScript(image, R, sigma);

image(result);
