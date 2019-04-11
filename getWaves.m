function [waves] = getWaves(patch, window, R)
    patch = patch.*window;
    imshow(patch);
    Smn = fftshift(fft2(patch));
    imshow(uint8(abs(Smn)));
    
    [M, N] = size(Smn);
    waves = [];
    alpha_max = 0;
    currentEnergy = sum(sum(conj(Smn).*Smn));

    while size(waves) < 10
        % Find indices of maximum value in |Smn|
        maxLocation = getMaxPixelInSmn(Smn, R);
        if (maxLocation == -1)
            break;
        end
        k_dash = maxLocation(1);
        l_dash = maxLocation(2);

        % fit quadratic Q to log(|Smn|) around (k_dash, l_dash)
        [Q, fitobject] = fitQuadratic(Smn, k_dash, l_dash);
        
        k_dash = k_dash - M/2;
        l_dash = l_dash - N/2;

        % break if hessian of Q is not negative definite
        C = coeffvalues(fitobject);
        syms x y
        f = C(1) + C(2)*x + C(3)*y + C(4)*x^2 + C(5)*x*y + C(6)*y^2;
        H = double(jacobian(gradient(f))); % hessian

        isHPositive = 1; % flag to check for positiveness
        for k = 1:size(H, 1)
            subH = H(1:k, 1:k);
            if(det(subH) <= 0)
                isHPositive = 0;
                break;
            end
        end

        if isHPositive
            break;
        end

        % compute frequencies (a_dash, b_dash)
        [Max, I] = max(Q);
        [M1, I1] = max(Max);
        a_dash_raw = I(I1);
        b_dash_raw = I1;
        a_dash = a_dash_raw - M/2;
        b_dash = b_dash_raw - N/2;

        % break if (a_dash, b_dash) falls outside 3x3 neighborhood of
        % (k_dash, l_dash)
        if (a_dash < k_dash - 1 || a_dash > k_dash + 1 || b_dash < l_dash - 1 || b_dash > l_dash + 1)
            break;
        end

        % compute amplitude alpha_dash
        alpha_dash = computeAmplitude(Q, a_dash_raw, b_dash_raw, window);

        % break if alpha_dash < alpha_max/4; else alpha_max =
        % max(alpha_dash, alpha_max)
        if alpha_dash < alpha_max/4
            break;
        end
        alpha_max = max(alpha_max, alpha_dash);

        % compute phase c_dash
        wave = [alpha_dash, a_dash/M, b_dash/N, 0];
        w = zeros(M, N);
        for m = 1:M
            for n = 1:N
                w(m, n) = wave(1) * exp(2 * pi * sqrt(-1) * (wave(2) * m + wave(3) * n + 0));
            end
        end

        Wmn0 = fftshift(fft2(w.*window));
        d = sum(sum(conj(Wmn0).*Smn));
        c1 = mod(atan2(-imag(d), real(d))/(2*pi), 1);
        c2 = mod(atan2(imag(d), -real(d))/(2*pi), 1);
        f1 = cos(2*pi*c1)*real(d) - sin(2*pi*c1)*imag(d);
        f2 = cos(2*pi*c2)*real(d) - sin(2*pi*c2)*imag(d);
        if f1 > f2
            wave(4) = c1;
        else
            wave(4) = c2;
        end

        % remove detected wave from Smn
        Wmn = Wmn0 * exp(2 * pi * sqrt(-1) * wave(4));
%         imshow(uint8(abs(Wmn)));
        SmnOld = Smn;
        SmnTemp = Smn - Wmn;
        energyTemp = sum(sum(SmnTemp.*conj(SmnTemp)));
        
        if energyTemp >= currentEnergy
            Smn = Smn + Wmn;
        else
            Smn = Smn - Wmn;
        end
%         imshow(uint8(abs(Smn)));

        % break if energy ||Smn||^2 did not decrease
        energy = sum(sum(Smn.*conj(Smn)));
        if energy >= currentEnergy
            Smn = SmnOld;
            break;
        end
        currentEnergy = energy;
        waves = [waves;wave];
    end
    
    imshow(uint8(abs(Smn)));
    imshow(abs(ifft2(ifftshift(Smn))));
end