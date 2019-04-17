function [res] = getMaxPixelInSmn(Smn, R)
    % get max
    SmnAbs = log10(abs(Smn).^2);
    [M_Smn, N_Smn] = size(SmnAbs);
    for i = 1:M_Smn
        for j = 1:N_Smn
            spectralCircleRadius = 0.4 * M_Smn / R;
            currentRadius = sqrt((i - M_Smn/2)^2 + (j - N_Smn/2)^2);
            if currentRadius <= spectralCircleRadius
                SmnAbs(i, j) = 0;
            end
        end
    end
    
%     figure, imagesc(SmnAbs);
    
    [M, I] = max(SmnAbs);
    [M1, I1] = max(M);
    res = [I(I1), I1];
    if (M1 == 0)
        res = -1;
    end
end