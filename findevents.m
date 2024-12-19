function[bookmarks] = findevents(filt, pretime, diaFrequency, pleth, plethFrequency, CriticalPleth, timeRMS, sgtime, slopeoffset, multiplier, mmpoints, ratio)

    try
    %% Set up downsample
    
    down = downsample(filt, 10);
    timedown = downsample(pretime, 10);
    downFrequency = diaFrequency/10;
    
    
    if numel(pleth) > numel(down)
        pleth = pleth(1:numel(down));
    elseif numel(pleth) < numel(down)
        down = down(1:numel(pleth));
    end
    
    if numel(down) > numel(timedown)
        down = down(1:numel(timedown));
    elseif numel(timedown) > numel(down)
        timedown = timedown(1:numel(down));
    end
    
    %% Compute RMS
    
    nRMS = ceil(timeRMS*downFrequency);
    r = rem(nRMS, 2);
    if r == 1
        nRMS = nRMS + 1;
    end
    offsetRMS = nRMS/2;
    RMS = zeros(numel(timedown), 1);
    
    for a = offsetRMS+1:numel(timedown)-offsetRMS
        section = down(a-offsetRMS:a+offsetRMS);
        RMS(a) = rms(section);
    end
    
    for b = 1:offsetRMS
        RMS(b) = RMS(offsetRMS+1);
    end
    
    for c = numel(timedown)-offsetRMS+1:numel(timedown)
        RMS(c) = RMS(numel(timedown)-offsetRMS);
    end
    
    %% SG filter
    
    framelen = ceil(sgtime*downFrequency);
    r = rem(framelen, 2);
    if r == 0
        framelen = framelen + 1;
    end
    
    SGfilt = sgolayfilt(RMS, 2, framelen);
    
    %% Slope of SG filter
    
    slopeoffset = ceil(slopeoffset*downFrequency);
    r = rem(slopeoffset, 2);
    if r == 1
        slopeoffset = slopeoffset + 1;
    end
    slopeoffset = slopeoffset/2;
    
    time = slopeoffset*2/downFrequency;
    Slope = zeros(numel(timedown), 1);
    for d = slopeoffset+1:numel(timedown)-slopeoffset
        Slope(d) = (SGfilt(d+slopeoffset)-SGfilt(d-slopeoffset))/time;
    end
    
    %% Find slope critical points
    
    count = 1;
    Critical = zeros(1, 4);
    
    for e = slopeoffset+2:numel(Slope)-slopeoffset
        if Slope(e-1) < 0 && Slope(e) >= 0
            Critical(count, 1) = e;
            Critical(count+1, 1) = 0;
        elseif Slope(e-1) > 0 && Slope(e) <= 0 && Critical(count, 1) ~= 0 
            Critical(count, 3) = e;
            count = count + 1;
        end
    end
    
    Critical = Critical(1:end-1, :);
    
    max = 0;
    maxspot = -1;
    min = 0;
    minspot = -1;
    for f = 1:numel(Critical(:, 1))-1
        for g = Critical(f, 1):Critical(f, 3)
            if Slope(g) > max
                max = Slope(g);
                maxspot = g;
            end
        end
        for g = Critical(f, 3):Critical(f+1, 1)
            if Slope(g) < min
                min = Slope(g);
                minspot = g;
            end
        end
        Critical(f, 2) = maxspot;
        Critical(f, 4) = minspot;
        max = 0;
        maxspot = -1;
        min = 0;
        minspot = -1;
    end
    
    Critical = Critical(1:end-1, :);
    EndsCrit = Critical;
    
    %% Find high and low values
    
    for h = 1:numel(Critical(:, 1))
        highs(h,1) = SGfilt(Critical(h, 3));
        lows(h,1) = SGfilt(Critical(h, 1));
    end
    
    
    high = median(highs)/multiplier;
    low = quantile(lows, 0.25);
    for i = 1:numel(highs)
        if highs(i) < high
            highs(i) = -1000;
            lows(i) = -1000;
            Critical(i, :) = -1000;
        elseif lows(i) > low
            highs(i) = -1000;
            lows(i) = -1000;
            Critical(i, :) = -1000;
        end
    end
    
    
    delete = (highs == -1000);
    highs(delete,:) = [];
    delete = (lows == -1000);
    lows(delete,:) = [];
    delete = (Critical == -1000);
    Critical(delete(:, 1), :) = [];
    
    %% Generate high low moving medians and threshold
    
    mmpoints = ceil(mmpoints/2);
    baselines = zeros(numel(down), 3);
    
    Low = median(lows(1:mmpoints*2, 1));
    High = median(highs(1:mmpoints*2,1));
    baselines(1:Critical(mmpoints-1, 1), 1) = Low;
    baselines(1:Critical(mmpoints-1, 3), 2) = High;
    
    
    for j = mmpoints:numel(Critical(:, 1))-mmpoints
        Low = median(lows(j-mmpoints+1:j+mmpoints));
        High = median(highs(j-mmpoints+1:j+mmpoints));
        baselines(Critical(j-1, 1):Critical(j, 1), 1) = Low;
        baselines(Critical(j-1, 3):Critical(j, 3), 2) = High;
    end
    
    baselines(Critical(j+1, 1):end, 1) = Low;
    baselines(Critical(j+1, 3):end, 2) = High;
    
    
    for k = 1:numel(baselines(:, 1))
        baselines(k, 3) = baselines(k, 1) + (baselines(k, 2)-baselines(k, 1))*ratio;
    end
    
    %% Complete bookmarking
    
    liststart = EndsCrit(:, 2);
    listend = EndsCrit(:, 4);
    CriticalPleth = CriticalPleth(2:end, :);
    events = zeros(numel(CriticalPleth(:, 1)), 4);
    events(:, 1) = CriticalPleth(:, 1);
    events(:, 2) = CriticalPleth(:, 3);
    crossings = zeros(1, 2);
    
    for n = 1:numel(baselines(:, 3))-1
        if SGfilt(n) - baselines(n, 3) <= 0 && SGfilt(n+1) - baselines(n+1, 3) > 0
            crossings(end+1, 1) = n;
        elseif SGfilt(n) - baselines(n, 3) == 0 && SGfilt(n+1) - baselines(n+1, 3) == 0
            crossings(end+1, 1) = n;
            crossings(end, 2) = n;
        elseif SGfilt(n) - baselines(n, 3) >= 0 && SGfilt(n+1) - baselines(n+1, 3) < 0
            crossings(end, 2) = n;
        end
    end
    
    
    
    crossings = crossings(2:end-1, :);
    
    lastend = 0;
    listind = 2;
    crossind = 2;
    for o = 1:numel(CriticalPleth(:, 1))-1
        while crossind < numel(crossings(:, 1)) && crossings(crossind, 1) < CriticalPleth(o, 1)
            crossind = crossind + 1;
        end
    
        starts = crossings(crossind-1, 1);
    
        while crossind < numel(crossings(:, 1)) && crossings(crossind, 2) < CriticalPleth(o, 3)
            crossind = crossind + 1;
        end
        if abs(crossings(crossind, 2) - CriticalPleth(o, 3)) < abs(crossings(crossind-1, 2) - CriticalPleth(o, 3))
            ends = crossings(crossind, 2);
        else
            ends = crossings(crossind-1, 2);
        end
    
        while liststart(listind) < starts
            listind = listind + 1;
        end
        
        if abs(liststart(listind) - starts) > abs(liststart(listind-1)-starts)
            beginning = liststart(listind - 1);
            listind = listind - 1;
        else
            beginning = liststart(listind);
        end
    
        while listend(listind) < ends
            listind = listind + 1;
        end
        
        if abs(listend(listind) - ends) > abs(listend(listind-1)-ends)
            ending = ends;
            listind = listind - 1;
        else
            ending = listend(listind);
        end
    
    
        if o ~= 1 && beginning > lastend && beginning > events(o-1, 2) && ending > beginning && ending < events(o+1, 1)
            events(o, 3) = beginning;
            events(o, 4) = ending;
            lastend = ending;
        elseif o == 1
            events(o, 3) = beginning;
            events(o, 4) = ending;
            lastend = ending;
        else
            listind = listind - 1;
            continue
        end
        listind = listind - 1;
    end

    events(:, 3:4) = events(:, 3:4)*10;

    bookmarks = events;
    
    % breaths = -100*ones(numel(timedown), 1);
    % 
    % for p = 1:numel(events(:, 1))
    %     if events(p, 3) ~= 0
    %         for q = events(p, 3):events(p, 4)
    %             breaths(q, 1) = 0;
    %         end
    %     end
    % end

    % zero = zeros(numel(events(:, 1)), 1);
    % hold off
    % plot(timedown, down, timedown, SGfilt, timedown, baselines(:, 1), timedown, baselines(:, 2), timedown, baselines(:, 3));
    % hold on
    % plot(events(:, 1)/plethFrequency, zero, '*g', events(:, 2)/plethFrequency, zero, 'xg', events(:, 3)/plethFrequency, zero, '*r', events(:, 4)/plethFrequency, zero, 'xr', timedown, breaths(:, 1), '*')
    % 
    % xlim([0 2])
    % ylim([-0.1 0.1])
    % hold off
    catch
        bookmarks = zeros(numel(CriticalPleth(:, 1)), 4);
        bookmarks(:, 1) = CriticalPleth(:, 1);
        bookmarks(:, 2) = CriticalPleth(:, 3);
        x = 'Error encountered'
    end


end
