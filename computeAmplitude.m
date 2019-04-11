function [alpha_dash] = computeAmplitude(Q, a_dash, b_dash, window)
    window_fourier = fft2(window);
    [m, n] = size(window_fourier);
    numerator = exp(Q(a_dash, b_dash));
    denominator = window_fourier(1, 1);
    for i = -1:1
       for j = -1:1
           x = -2 * a_dash + i*m;
           y = -2 * b_dash + j*n;
           x = mod(x, m);
           y = mod(y, n);
           x = x + 1;
           y = y + 1;
           denominator = denominator + abs(window_fourier(x, y));
        end
    end
    alpha_dash = numerator/denominator;
end