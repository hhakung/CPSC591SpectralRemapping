function [remappedWaves] = remap(allWaves, R)
    remappedWaves = allWaves;
    for i = 1:size(remappedWaves, 1)
        for j = 1:size(remappedWaves, 2)
            waves = remappedWaves{i,j};
            number_of_waves = size(waves, 1);
            
            for k = 1:number_of_waves
                wave = waves(k,:);
                theta = atan2(wave(3), wave(2));
                wave(2) = 0.4 * cos(theta)/R;
                wave(3) = 0.4 * sin(theta)/R;
                remappedWaves{i, j}(k, 2) = wave(2);
                remappedWaves{i, j}(k, 3) = wave(3);
            end
        end
    end
end