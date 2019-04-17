function [Q, fitobject] = fitQuadratic(Smn, k_dash, l_dash)
    SmnLogAbs = log10(abs(Smn).^2);
    
    % 3x3 neighborhood centered at (k_dash, l_dash)
    % if k_dash or l_dash is 1 or size(Smn, 1) or size(Smn, 2)
    % then move the window center to either k_dash + 1, l_dash + 1 or
    % k_dash - 1, l_dash -1
    SmnLogAbsAroundMax = [];
    k_dash_new = k_dash;
    l_dash_new = l_dash;
    if (k_dash == 1)
        k_dash_new = k_dash + 1;
    elseif (k_dash == size(SmnLogAbs, 1))
        k_dash_new = k_dash - 1;
    end
    
    if (l_dash == 1)
        l_dash_new = l_dash + 1;
    elseif (l_dash == size(SmnLogAbs, 2))
        l_dash_new = l_dash - 1;
    end
    
    SmnLogAbsAroundMax = SmnLogAbs(k_dash_new-1:k_dash_new+1, l_dash_new-1:l_dash_new+1);
    
    [X, Y] = ndgrid(k_dash_new-1:k_dash_new+1, l_dash_new-1:l_dash_new+1);
    fitobject = fit([X(:), Y(:)], SmnLogAbsAroundMax(:), 'poly22');
    % plot(fitobject, [X(:), Y(:)], SmnLogAbsAroundMax(:));
    
    Q = [];
    for k = 1:size(Smn, 1)
        for l = 1:size(Smn, 2)
            Q(k, l) = fitobject(k, l);
        end
    end
end