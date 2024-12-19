clear
clc

analysisdate = '4_19_24';

filelist = dir('*.mat');
names = {filelist.name};


    timeRMS = 0.005; %time constant for RMS in seconds
    sgtime = 0.031; %time constant for SG filter in seconds
    slopeoffset = 0.005; %how far points are in determining slope in seconds
    multiplier = 1.5;
    mmpoints = 4; %number of points used for moving median
    ratio = 0.2; %what percentage up from low value to set threshold
    mintime = 0.025; %lowest period of negative pressure to be considered an event
    parnum = numel(names);
    

for i = 1:parnum
    tic
    filename = names{i};
    time = load(filename, 'time');
    time = time.time;
    plethFrequency = load(filename, 'plethFrequency');
    plethFrequency = plethFrequency.plethFrequency;
    diaFrequency = load(filename, 'diaFrequency');
    diaFrequency = diaFrequency.diaFrequency;
    rightfilt = load(filename, 'rightfilt');
    rightfilt = rightfilt.rightfilt;
    pleth = load(filename, 'pleth');
    pleth = pleth.pleth;
    Tv = load(filename, 'Tv');
    Tv = Tv.Tv;
    NormTv = load(filename, 'NormTv');
    NormTv = NormTv.NormTv;

    CriticalPleth = runpleth(pleth, mintime, plethFrequency);
    
    bookmarksR = findevents(rightfilt, time, diaFrequency, pleth, plethFrequency, CriticalPleth, timeRMS, sgtime, slopeoffset, multiplier, mmpoints, ratio);
    

    [DutyCycle, Ti, Te, Rate, Starts, Ends, Latency1, Latency2, Latency3, Latency4, PlethPeak, PlethAUC, PlethExpAUC, PlethExpPeak, VtPeak, VtAUC, VtExpAUC, VtExpPeak, NormVtPeak, NormVtAUC, NormVtExpAUC, NormVtExpPeak, EMGPeak, EMGAUC, EMGRMS75]...
        = outputcharacteristics(bookmarksR, rightfilt, Tv, NormTv, pleth, plethFrequency, diaFrequency, time);


    keep = ~(bookmarksR(:, 3) == 0);
    DutyCycle = DutyCycle(keep, :);
    Ti = Ti(keep, :);
    Te = Te(keep, :);
    Rate = Rate(keep, :);
    Starts = Starts(keep, :);
    Ends = Ends(keep, :);
    Latency1 = Latency1(keep, :);
    Latency2 = Latency2(keep, :);
    Latency3 = Latency3(keep, :);
    Latency4 = Latency4(keep, :);

    PlethPeak = PlethPeak(keep, :);
    PlethAUC = PlethAUC(keep, :);
    PlethExpAUC = PlethExpAUC(keep, :);
    PlethExpPeak = PlethExpPeak(keep, :);
    VtPeak = VtPeak(keep, :);
    VtAUC = VtAUC(keep, :);
    VtExpAUC = VtExpAUC(keep, :);
    VtExpPeak = VtExpPeak(keep, :);
    NormVtPeak = NormVtPeak(keep, :);
    NormVtAUC = NormVtAUC(keep, :);
    NormVtExpAUC = NormVtExpAUC(keep, :);
    NormVtExpPeak = NormVtExpPeak(keep, :);
    EMGPeak = EMGPeak(keep, :);
    EMGAUC = EMGAUC(keep, :);
    EMGRMS75 = EMGRMS75(keep, :);

    DutyCycle = DutyCycle(1:end-1);
    Ti = Ti(1:end-1);
    Te = Te(1:end-1);
    Rate = Rate(1:end-1);
    Starts = Starts(1:end-1);
    Ends = Ends(1:end-1);
    Latency1 = Latency1(1:end-1);
    Latency2 = Latency2(1:end-1);
    Latency3 = Latency3(1:end-1);
    Latency4 = Latency4(1:end-1);

    PlethPeak = PlethPeak(1:end-1);
    PlethAUC = PlethAUC(1:end-1);
    PlethExpAUC = PlethExpAUC(1:end-1);
    PlethExpPeak = PlethExpPeak(1:end-1);
    VtPeak = VtPeak(1:end-1);
    VtAUC = VtAUC(1:end-1);
    VtExpAUC = VtExpAUC(1:end-1);
    VtExpPeak = VtExpPeak(1:end-1);
    NormVtPeak = NormVtPeak(1:end-1);
    NormVtAUC = NormVtAUC(1:end-1);
    NormVtExpAUC = NormVtExpAUC(1:end-1);
    NormVtExpPeak = NormVtExpPeak(1:end-1);
    EMGPeak = EMGPeak(1:end-1);
    EMGAUC = EMGAUC(1:end-1);
    EMGRMS75 = EMGRMS75(1:end-1);


    basefile = extractBefore(filename, '_structure.mat');
    newfile = strcat(basefile, '_analyzed.mat');

    save(newfile, 'DutyCycle', 'Ti', 'Te', 'Rate', 'Starts', 'Ends', 'Latency1', 'Latency2', 'Latency3', 'PlethPeak', 'PlethAUC', 'PlethExpAUC', 'PlethExpPeak', 'VtPeak', 'VtAUC', 'VtExpAUC', 'VtExpPeak', 'NormVtPeak', 'NormVtAUC', 'NormVtExpAUC', 'NormVtExpPeak', 'EMGPeak', 'EMGAUC', 'EMGRMS75')
    toc
end







