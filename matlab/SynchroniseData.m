%change session number before each script run
session = '1';
%read and parse codebook
codebookpath = strcat('/Users/ashankbehara/desktop/FIND-Wheels/Session',session); 
codebookdata = csvread(strcat(codebookpath,'/Codebook_Pilot.csv'));
codebooklines = codebook(:,1);
totaltrials = length(codebooklines);
%read data by trial
for trial = 1 : totaltrials
    %Check for trial recorded
    codebooktrial = codebook(trial,:);
    if codebooktrial(1,1) == 0
        continue
    end 
    %read all trial specific data
    trialstring = int2str(trial);
    path = strcat(codebookpath,'/Trial',trialstring);
    ViconFileName = 'Aditya_20_Vicon.csv';
    GENEActivFileName = 'Aditya_20_GA_Wrist.csv';
    FPFileName = 'Aditya20_FP_RAWDATA.csv';
    Vicondata = csvread(strcat(path,'/',ViconFileName));
    GENEdata = csvread(strcat(path,'/',GENEActivFileName));
    FPdata = csvread(strcat(path,'/' ,FPFileName));
   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % TRUNCATING DATA BY START TIME % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   
    %Vicon Truncation
    ViconStartTime = codebooktrial(1,3);
    ViconFrames = Vicondata(:,1);
    RowStartIndex = 1;
    for i = 1:length(ViconFrames)
        if ViconFrames(i) == ViconStartTime
            RowStartIndex = ViconFrames(i);
            break
        end
    end
    Vicondata = Vicondata(RowStartIndex:end,:);
    %GENEActiv Truncation
    GENEStartTime = codebooktrial(1,4);
    GENETime = GENEdata(:,1);
    RowStartIndex = 1;
    for i = 1:length(GENETime)
        if GENETime(i) == GENEStartTime
            RowStartIndex = GENETime(i);
            break
        end
    end
    GENEdata = GENEdata(RowStartIndex:end,:);
    %FP Truncation
    
    
    %end of trial analysis
end

