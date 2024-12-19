function [DutyCycle, Ti, Te, Rate, Starts, Ends, Latency1, Latency2, Latency3, Latency4, PlethPeak, PlethAUC, PlethExpAUC, PlethExpPeak, VtPeak, VtAUC, VtExpAUC, VtExpPeak, NormVtPeak, NormVtAUC, NormVtExpAUC, NormVtExpPeak, EMGPeak, EMGAUC, EMGRMS75] ...
    = outputcharacteristics(bookmarks, rightfilt, Tv, NormTv, pleth, plethFrequency, diaFrequency, pretime)

    timeRMS = 0.05;

    nRMS = ceil(timeRMS*diaFrequency);
    r = rem(nRMS, 2);
    if r == 1
        nRMS = nRMS + 1;
    end
    offsetRMS = nRMS/2;
    RMSR = zeros(numel(pretime), 1);

    for a = offsetRMS+1:numel(pretime)-offsetRMS
        sectionR = rightfilt(a-offsetRMS:a+offsetRMS);
        RMSR(a) = rms(sectionR);
    end
    
    for b = 1:offsetRMS
        RMSR(b) = RMSR(offsetRMS+1);
    end
    
    for c = numel(pretime)-offsetRMS+1:numel(pretime)
        RMSR(c) = RMSR(numel(pretime)-offsetRMS);
    end

   

    nRMS = ceil(timeRMS*diaFrequency);
    r = rem(nRMS, 2);
    if r == 1
        nRMS = nRMS + 1;
    end


    DutyCycle = zeros(numel(bookmarks(:, 1)), 1);
    Ti = zeros(numel(bookmarks(:, 1)), 1);
    Te = zeros(numel(bookmarks(:, 1)), 1);
    Rate = zeros(numel(bookmarks(:, 1)), 1);
    Starts = zeros(numel(bookmarks(:, 1)), 1);
    Ends = zeros(numel(bookmarks(:, 1)), 1);
    Latency1 = zeros(numel(bookmarks(:, 1)), 1);
    Latency2 = zeros(numel(bookmarks(:, 1)), 1);
    Latency3 = zeros(numel(bookmarks(:, 1)), 1);
    Latency4 = zeros(numel(bookmarks(:, 1)), 1);

    PlethPeak = zeros(numel(bookmarks(:, 1)), 1);
    PlethAUC = zeros(numel(bookmarks(:, 1)), 1);
    PlethExpAUC = zeros(numel(bookmarks(:, 1)), 1);
    PlethExpPeak = zeros(numel(bookmarks(:, 1)), 1);
    VtPeak = zeros(numel(bookmarks(:, 1)), 1);
    VtAUC = zeros(numel(bookmarks(:, 1)), 1);
    VtExpAUC = zeros(numel(bookmarks(:, 1)), 1);
    VtExpPeak = zeros(numel(bookmarks(:, 1)), 1);
    NormVtPeak = zeros(numel(bookmarks(:, 1)), 1);
    NormVtAUC = zeros(numel(bookmarks(:, 1)), 1);
    NormVtExpAUC = zeros(numel(bookmarks(:, 1)), 1);
    NormVtExpPeak = zeros(numel(bookmarks(:, 1)), 1);
    EMGPeak = zeros(numel(bookmarks(:, 1)), 1);
    EMGAUC = zeros(numel(bookmarks(:, 1)), 1);
    EMGRMS75 = zeros(numel(bookmarks(:, 1)), 1);



    for d = 1:numel(bookmarks(:, 1))-1

        plethbreath = pleth(bookmarks(d,1):bookmarks(d+1,1));
        PTtot = numel(plethbreath);
        PTi = bookmarks(d, 2) - bookmarks(d, 1);
        Peak = 0;
        High = 0;
        Area = 0;
        Areaexp = 0;
        for i = 1:PTi
            if plethbreath(i) < Peak
                Peak = plethbreath(i);
            end
            Area = Area + plethbreath(i)/plethFrequency;
        end
        for j = PTi:PTtot
            if plethbreath(j) > High
                High = plethbreath(j);
            end
            Areaexp = Areaexp + plethbreath(j)/plethFrequency;
        end
        PlethPeak(d, 1) = Peak;
        PlethAUC(d, 1) = Area;
        PlethExpPeak(d, 1) = High;
        PlethExpAUC(d, 1) = Areaexp;
        
        plethbreath = Tv(bookmarks(d,1):bookmarks(d+1,1));
        PTtot = numel(plethbreath);
        PTi = bookmarks(d, 2) - bookmarks(d, 1);
        Peak = 0;
        High = 0;
        Area = 0;
        Areaexp = 0;
        for i = 1:PTi
            if plethbreath(i) < Peak
                Peak = plethbreath(i);
            end
            Area = Area + plethbreath(i)/plethFrequency;
        end
        for j = PTi:PTtot
            if plethbreath(j) > High
                High = plethbreath(j);
            end
            Areaexp = Areaexp + plethbreath(j)/plethFrequency;
        end
        VtPeak(d, 1) = Peak;
        VtAUC(d, 1) = Area;
        VtExpPeak(d, 1) = High;
        VtExpAUC(d, 1) = Areaexp;
       
        plethbreath = NormTv(bookmarks(d,1):bookmarks(d+1,1));
        PTtot = numel(plethbreath);
        PTi = bookmarks(d, 2) - bookmarks(d, 1);
        Peak = 0;
        High = 0;
        PeakTime = 0;
        Area = 0;
        Areaexp = 0;
        for i = 1:PTi
            if plethbreath(i) < Peak
                Peak = plethbreath(i);
                PeakTime = i + bookmarks(d, 1);
            end
            Area = Area + plethbreath(i)/plethFrequency;
        end
        for j = PTi:PTtot
            if plethbreath(j) > High
                High = plethbreath(j);
            end
            Areaexp = Areaexp + plethbreath(j)/plethFrequency;
        end
        NormVtPeak(d, 1) = Peak;
        NormVtAUC(d, 1) = Area;
        NormVtExpPeak(d, 1) = High;
        NormVtExpAUC(d, 1) = Areaexp;

        if bookmarks(d, 3) ~= 0
            Latency1(d, 1) = bookmarks(d, 1)/plethFrequency - bookmarks(d, 3)/diaFrequency;
            Latency2(d, 1) = PeakTime/plethFrequency - bookmarks(d, 3)/diaFrequency;
            Latency3(d, 1) = bookmarks(d, 4)/diaFrequency - bookmarks(d, 2)/plethFrequency;
        end
  
        if bookmarks(d, 3) ~= 0
            next = d+1;
            while bookmarks(next,3) == 0
                next = next + 1;
                if next > numel(bookmarks(:, 1))
                    break
                end
            end
            if next > numel(bookmarks(:, 1))
                continue
            end
            rightbreath = RMSR(bookmarks(d,3):bookmarks(next,3));
            RTtot = numel(rightbreath);
            RTi = bookmarks(d, 4) - bookmarks(d, 3);
            Peak = 0;
            PeakInt = 0;
            Area = 0;
            for i = 1:RTi
                if rightbreath(i) > Peak
                    Peak = rightbreath(i);
                    PeakInt = i + bookmarks(d, 3);
                end
                Area = Area + (rightbreath(i))/diaFrequency;
            end
            if ceil(0.075*diaFrequency) < numel(rightbreath)
                EMGRMS75(d, 1) = rightbreath(ceil(0.075*diaFrequency));
            else
                EMGRMS75(d, 1) = 1/0;
            end
            EMGPeak(d, 1) = Peak;
            EMGAUC(d, 1) = Area;
            Starts(d,1) = bookmarks(d, 3)/diaFrequency;
            Ends(d, 1) = bookmarks(d, 3)/diaFrequency;
            Latency4(d, 1) = PeakInt/diaFrequency - PeakTime/plethFrequency;
            Rate(d, 1) = 60/((bookmarks(d+1, 1)-bookmarks(d, 1))/plethFrequency);
            Ti(d,1) = RTi/diaFrequency;
            if bookmarks(d+1, 3) ~= 0
                DutyCycle(d, 1) = ((bookmarks(d, 4)-bookmarks(d, 3))/diaFrequency)/((bookmarks(d+1, 3)-bookmarks(d, 3))/diaFrequency);
                Te(d,1) = (bookmarks(d+1, 3)-bookmarks(d, 3))/diaFrequency - (bookmarks(d, 4)-bookmarks(d, 3))/diaFrequency;
            else
                DutyCycle(d, 1) = ((bookmarks(d, 4)-bookmarks(d, 3))/diaFrequency)/((bookmarks(d+1, 1)-bookmarks(d, 1))/plethFrequency);
                Te(d,1) = (bookmarks(d+1, 1)-bookmarks(d, 1))/plethFrequency - (bookmarks(d, 4)-bookmarks(d, 3))/diaFrequency;
            end
        end

end


