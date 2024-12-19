clc
clear

filelist = dir('*_analyzed.mat');
names = {filelist.name};

parnum = numel(names);
    



for j = 1:parnum
    clear BreathType
    filename = names{j};
    animal = extractBefore(filename, '_');
    time = extractAfter(filename, '_');
    challenge = extractAfter(time, '_');
    time = extractBefore(time, '_');
    challenge = extractBefore(challenge, '.mat');
    animal = str2double(animal);
    time = str2double(time);
    challenge = extract(challenge, 5);
    challenge = char(challenge);
        
        
        name = extractBefore(filename, '_Baseline_analyzed.mat');
        Hypoxia = strcat(name, '_Hypoxia_analyzed.mat');
        Hypercapnia = strcat(name, '_Hypercapnia_analyzed.mat');
        MaxChemo = strcat(name, '_Max Chemo_analyzed.mat');

        if challenge == 'l'
            load(filename);
            clear BreathType 
            
            limit1 = 0.4;
            limit2 = prctile(VtPeak(:), 10);
            limit3 = prctile(EMGPeak(:), 90);

            limit4 = prctile(VtPeak(:), 50);
            limit5 = prctile(EMGPeak(:), 25);

            limit6 = prctile(VtPeak(:), 25);
            limit7 = prctile(EMGPeak(:), 75);

            limit8 = 0.15;
            limit9 = 240;


            for i = 1:numel(Ti)-1
                if Ti(i,1) > limit1 && EMGPeak(i, 1) > limit3 && VtPeak(i, 1) < limit2
                    BreathType(i, 1) = 3;
                elseif Ti(i, 1) < limit8 && EMGPeak(i, 1) > limit5 && VtPeak(i, 1) < limit4 && Rate(i, 1) > limit9
                    BreathType(i, 1) = 2;
                elseif Ti(i, 1) > limit8 && EMGPeak(i, 1) < limit7 && VtPeak(i, 1) > limit6 
                    BreathType(i, 1) = 1;
                else
                    BreathType(i, 1) = 0;
                end
            end


            for i = 2:numel(BreathType) - 1
                if BreathType(i-1) == 1 && BreathType(i+1) == 1 && BreathType(i) ~= 3
                    BreathType(i) = 1;
                elseif BreathType(i-1) == 2 && BreathType(i+1) == 2 && BreathType(i) ~= 3
                    BreathType(i) = 2;
                end
            end

            
            for i = 3:numel(BreathType) - 2
                if BreathType(i-2) == 1 && BreathType(i+2) == 1 && BreathType(i) ~= 3
                    BreathType(i) = 1;
                elseif BreathType(i-2) == 2 && BreathType(i+2) == 2 && BreathType(i) ~= 3
                    BreathType(i) = 2;
                end
            end




            save(filename, 'BreathType', '-append')
            clear animal BreathType challenge DutyCycle EMGAUC EMGPeak EMGRMS75 Ends i j Latency1 Latency2 Latency3 name time VtAUC VtExpAUC VtExpPeak VtPeak
            clear NormVtAUC NormVtExpAUC NormVtExpPeak NormVtPeak PlethAUC PlethExpAUC PlethExpPeak PlethPeak Rate Starts Te Ti

           
            try
                load(Hypoxia)
                clear BreathType 
            for i = 1:numel(Ti)-1
                if Ti(i,1) > limit1 && EMGPeak(i, 1) > limit3 && VtPeak(i, 1) < limit2
                    BreathType(i, 1) = 3;
                elseif Ti(i, 1) < limit8 && EMGPeak(i, 1) > limit5 && VtPeak(i, 1) < limit4 && Rate(i, 1) > limit9
                    BreathType(i, 1) = 2;
                elseif Ti(i, 1) > limit8 && EMGPeak(i, 1) < limit7 && VtPeak(i, 1) > limit6
                    BreathType(i, 1) = 1;
                else
                    BreathType(i, 1) = 0;
                end
            end

            for i = 2:numel(BreathType) - 1
                if BreathType(i-1) == 1 && BreathType(i+1) == 1 && BreathType(i) ~= 3
                    BreathType(i) = 1;
                elseif BreathType(i-1) == 2 && BreathType(i+1) == 2 && BreathType(i) ~= 3
                    BreathType(i) = 2;
                end
            end
            
            for i = 3:numel(BreathType) - 2
                if BreathType(i-2) == 1 && BreathType(i+2) == 1 && BreathType(i) ~= 3
                    BreathType(i) = 1;
                elseif BreathType(i-2) == 2 && BreathType(i+2) == 2 && BreathType(i) ~= 3
                    BreathType(i) = 2;
                end
            end
            
    
                save(Hypoxia, 'BreathType', '-append')
                clear animal BreathType challenge DutyCycle EMGAUC EMGPeak EMGRMS75 Ends i j Latency1 Latency2 Latency3 name time VtAUC VtExpAUC VtExpPeak VtPeak
                clear NormVtAUC NormVtExpAUC NormVtExpPeak NormVtPeak PlethAUC PlethExpAUC PlethExpPeak PlethPeak Rate Starts Te Ti
            catch
                x = 'Missing'
                Hypoxia
            end

            try
                load(MaxChemo)
                clear BreathType
            for i = 1:numel(Ti)-1
                if Ti(i,1) > limit1 && EMGPeak(i, 1) > limit3 && VtPeak(i, 1) < limit2
                    BreathType(i, 1) = 3;
                elseif Ti(i, 1) < limit8 && EMGPeak(i, 1) > limit5 && VtPeak(i, 1) < limit4 && Rate(i, 1) > limit9
                    BreathType(i, 1) = 2;
                elseif Ti(i, 1) > limit8 && EMGPeak(i, 1) < limit7 && VtPeak(i, 1) > limit6
                    BreathType(i, 1) = 1;
                else
                    BreathType(i, 1) = 0;
                end
            end

            for i = 2:numel(BreathType) - 1
                if BreathType(i-1) == 1 && BreathType(i+1) == 1 && BreathType(i) ~= 3
                    BreathType(i) = 1;
                elseif BreathType(i-1) == 2 && BreathType(i+1) == 2 && BreathType(i) ~= 3
                    BreathType(i) = 2;
                end
            end
            
            for i = 3:numel(BreathType) - 2
                if BreathType(i-2) == 1 && BreathType(i+2) == 1 && BreathType(i) ~= 3
                    BreathType(i) = 1;
                elseif BreathType(i-2) == 2 && BreathType(i+2) == 2 && BreathType(i) ~= 3
                    BreathType(i) = 2;
                end
            end
            
            for i = 4:numel(BreathType) - 3
                if BreathType(i-3) == 1 && BreathType(i+3) == 1 && BreathType(i) ~= 3
                    BreathType(i) = 1;
                elseif BreathType(i-3) == 2 && BreathType(i+3) == 2 && BreathType(i) ~= 3
                    BreathType(i) = 2;
                end
            end
    
                save(MaxChemo, 'BreathType', '-append')
                clear animal BreathType challenge DutyCycle EMGAUC EMGPeak EMGRMS75 Ends i j Latency1 Latency2 Latency3 name time VtAUC VtExpAUC VtExpPeak VtPeak
                clear NormVtAUC NormVtExpAUC NormVtExpPeak NormVtPeak PlethAUC PlethExpAUC PlethExpPeak PlethPeak Rate Starts Te Ti
            catch
                x = 'Missing'
                MaxChemo
            end

            try
                load(Hypercapnia)
                clear BreathType
            for i = 1:numel(Ti)-1
                if Ti(i,1) > limit1 && EMGPeak(i, 1) > limit3 && VtPeak(i, 1) < limit2
                    BreathType(i, 1) = 3;
                elseif Ti(i, 1) < limit8 && EMGPeak(i, 1) > limit5 && VtPeak(i, 1) < limit4 && Rate(i, 1) > limit9
                    BreathType(i, 1) = 2;
                elseif Ti(i, 1) > limit8 && EMGPeak(i, 1) < limit7 && VtPeak(i, 1) > limit6
                    BreathType(i, 1) = 1;
                else
                    BreathType(i, 1) = 0;
                end
            end

            for i = 2:numel(BreathType) - 1
                if BreathType(i-1) == 1 && BreathType(i+1) == 1 && BreathType(i) ~= 3
                    BreathType(i) = 1;
                elseif BreathType(i-1) == 2 && BreathType(i+1) == 2 && BreathType(i) ~= 3
                    BreathType(i) = 2;
                end
            end
            
            for i = 3:numel(BreathType) - 2
                if BreathType(i-2) == 1 && BreathType(i+2) == 1 && BreathType(i) ~= 3
                    BreathType(i) = 1;
                elseif BreathType(i-2) == 2 && BreathType(i+2) == 2 && BreathType(i) ~= 3
                    BreathType(i) = 2;
                end
            end
            
    
                save(Hypercapnia, 'BreathType', '-append')
                clear animal BreathType challenge DutyCycle EMGAUC EMGPeak EMGRMS75 Ends i j Latency1 Latency2 Latency3 name time VtAUC VtExpAUC VtExpPeak VtPeak
                clear NormVtAUC NormVtExpAUC NormVtExpPeak NormVtPeak PlethAUC PlethExpAUC PlethExpPeak PlethPeak Rate Starts Te Ti
            catch
                x = 'Missing'
                Hypercapnia
            end




        end
end
