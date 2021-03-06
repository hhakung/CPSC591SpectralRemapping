function [alpha_dash] = computeAmplitude(Q, a_dash, b_dash, a_dash_raw, b_dash_raw, window)
    window_fourier = fft2(window);
    [m, n] = size(window_fourier);
    numerator = exp(Q(a_dash_raw, b_dash_raw));
    denominator = window_fourier(1, 1);
    window_fourier = fftshift(window_fourier);
    for i = -1:1
       for j = -1:1
           x = -2 * a_dash + i; % x coordinate after the shift
           y = -2 * b_dash + j; % y coordinate after the shift
           
           % un-shift
           x = x + m / 2;
           y = y + n / 2;
           
           % rounding and modulus
           x = mod(round(x), m) + 1;
           y = mod(round(y), n) + 1;
%            disp(x);
%            disp(y);
           denominator = denominator + abs(window_fourier(x, y));
        end
    end
    alpha_dash = numerator/denominator;
end