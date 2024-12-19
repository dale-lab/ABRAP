clear
clc

filelist = dir('*_analyzed.mat');
names = {filelist.name};

parnum = numel(names);
    



for j = 1:parnum
    clear BoutStart BoutLength BoutEvents BoutFrequency
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

            if challenge == 'l'
            load(filename);
            clear BoutStart BoutLength BoutEvents BoutFrequency

            i = 1;
            boutcount = 1;

            % while Starts(i) < 600
            %     i = i + 1;
            % end
            % 
            
            while i < numel(BreathType)-10
                if i <= numel(BreathType)-10 && BreathType(i) == 2 && BreathType(i+1) == 2 && BreathType(i+2) == 2 && BreathType(i+3) == 2 && BreathType(i+4) == 2 && BreathType(i+5) == 2 && BreathType(i+6) == 2 && BreathType(i+7) == 2 && BreathType(i+8) == 2 && BreathType(i+9) == 2 && BreathType(i + 10) == 2
                    BoutStart(boutcount,1) = Starts(i);
                    startind = i;
                    while i < numel(BreathType) && BreathType(i) == 2
                        i = i + 1;
                    end
                    BoutLength(boutcount,1) = Starts(i-1) - BoutStart(boutcount);
                    BoutEvents(boutcount,1) = i - 1 - startind;
                    BoutFrequency(boutcount,1) = mean(Rate(startind:i - 1));
                    while i <= numel(BreathType)-10 && BreathType(i) >= 2 && BreathType(i+1) >= 2 && BreathType(i+2) >= 2 && BreathType(i+3) >= 2 && BreathType(i+4) >= 2 && BreathType(i+5) >= 2 && BreathType(i+6) >= 2 && BreathType(i+7) >= 2 && BreathType(i+8) >= 2 
                        i = i + 1;
                    end
                    boutcount = boutcount + 1;
                end
                i = i + 1;
            end
            try
            save(filename, 'BoutStart', 'BoutLength', 'BoutEvents', 'BoutFrequency', '-append')
            catch
                filename
            end
            end
            
end
