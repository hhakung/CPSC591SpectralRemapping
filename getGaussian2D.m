function [G] = getGaussian2D(M, N, sigma)
    G = fspecial('gaussian', [M, N], sigma);
    [row, rowIndex] = max(G);
    [maximum, columnIndex] = max(row);
    G = G/maximum;
end