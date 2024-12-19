function[CriticalPleth] = runpleth(pleth, mintime, plethFrequency)
    count = 1;
    CriticalPleth = zeros(1, 4);
    
    for e = 2:numel(pleth)
        if pleth(e-1) > 0 && pleth(e) <= 0
            CriticalPleth(count, 1) = e;
            CriticalPleth(count+1, 1) = 0;
        elseif pleth(e-1) < 0 && pleth(e) >= 0 && CriticalPleth(count, 1) ~= 0
            CriticalPleth(count, 3) = e;
            count = count + 1;
        end
    end
    CriticalPleth = CriticalPleth(1:end-1, :);
    
    max = 0;
    maxspot = -1;
    min = 0;
    minspot = -1;
    for f = 1:numel(CriticalPleth(:, 1))-1
        for g = CriticalPleth(f, 1):CriticalPleth(f, 3)
            if pleth(g) < min
                min = pleth(g);
                minspot = g;
            end
        end
        for g = CriticalPleth(f, 1):CriticalPleth(f+1, 3)
            if pleth(g) > max
                max = pleth(g);
                maxspot = g;
            end
        end
        CriticalPleth(f, 4) = maxspot;
        CriticalPleth(f, 2) = minspot;
        max = 0;
        maxspot = -1;
        min = 0;
        minspot = -1;
    end
    
    CriticalPleth = CriticalPleth(1:end-2, :);
    
    distance = ceil(mintime*plethFrequency);
    
    for l = 1:numel(CriticalPleth(:, 1))
        if CriticalPleth(l, 3) - CriticalPleth(l, 1) < distance
            CriticalPleth(l, :) = -1000;
        end
    end
    
    delete = (CriticalPleth == -1000);
    CriticalPleth(delete(:, 1), :) = [];
    
    maxval = median(pleth(CriticalPleth(:, 2)))/4;
    for m = 1:numel(CriticalPleth(:, 1))
        if pleth(CriticalPleth(m, 2)) > maxval
            CriticalPleth(m, :) = -1000;
        end
    end
    
    delete = (CriticalPleth == -1000);
    CriticalPleth(delete(:, 1), :) = [];
end
