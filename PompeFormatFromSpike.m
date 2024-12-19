clear
clc

datecreated = '4_18_24';

filelist = dir('*.mat');
names = {filelist.name};

for i = 1:numel(names)
    filename = names{i};
    load(filename);
    
    animalnumber = extractBefore(filename, '_');
    animalage = extractAfter(filename, '_');
    challenge = extractAfter(animalage, '_');
    animalage = extractBefore(animalage, '_');
    challenge = extractBefore(challenge, '.mat');
    
    
    plethFrequency = 500;
    diaFrequency = 5000;
    
    
    right = who('*Ch2');
    right = right{1};
    right = eval(right);
    right = right.values;
    
    pleth = who('*Ch3');
    pleth = pleth{1};
    pleth = eval(pleth);
    pleth = pleth.values;
    
    Tv = who('*Ch11');
    Tv = Tv{1};
    Tv = eval(Tv);
    Tv = Tv.values;

    NormTv = who('*Ch12');
    NormTv = NormTv{1};
    NormTv = eval(NormTv);
    NormTv = NormTv.values;

    pleth = pleth(1:end-1);
    Tv = Tv(1:numel(pleth));
    NormTv = NormTv(1:numel(pleth));


    time = transpose((1/diaFrequency:1/diaFrequency:numel(right)/diaFrequency));

    
    e = designfilt('bandstopiir', 'FilterOrder', 2, 'HalfPowerFrequency1', 59.5, 'HalfPowerFrequency2', 60.5, 'DesignMethod', 'butter', 'SampleRate', 5000);
    rightnotch = filtfilt(e, right);
    
    
    e = designfilt('bandpassiir', 'FilterOrder', 2, 'HalfPowerFrequency1', 25, 'HalfPowerFrequency2', 500, 'DesignMethod', 'butter', 'SampleRate', diaFrequency);

    rightfilt = filtfilt(e, rightnotch);
    
    
    newfilename = strcat(animalnumber, '_', animalage, '_', challenge, '_structure.mat');
    
    save(newfilename, 'datecreated', 'animalage', 'challenge', 'animalnumber', 'diaFrequency', 'plethFrequency', 'pleth', 'Tv', 'NormTv', 'rightfilt', 'time');

    clear animalnumber diaFrequency e file filename left leftfilt leftnotch newfilename pleth plethFrequency right rightfilt rightnotch time V* animalage challenge fi NormTv Tv
    y = 0;
end