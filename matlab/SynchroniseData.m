%change session number before each script run
session = '1';
%read and parse codebook
codebookpath = strcat('/Users/ashankbehara/desktop/FIND-Wheels/Session',session); 
codebook = csvread(strcat(codebookpath,'/Codebook_Pilot.csv'));
codebookdata = codebook(5:end, 4:7);
totaltrials = length(codebookdata(:,1));
%read data by trial
for trial = 1 : totaltrials
    %Check for trial recorded
    codebooktrial = codebookdata(trial,:);
    if codebooktrial(1,1) == 0
        continue
    end 
    %read all trial specific data
    trialstring = int2str(trial);
    path = strcat(codebookpath,'/Trial',trialstring);
    ViconFileName = 'Aditya_20_Vicon.csv';
    GENEActivFileName = 'Aditya_20_GA_Wrist.csv';
    FPFileName = 'Aditya20_FP_RAWDATA.csv';
    %file names
    ViconFile = strcat(path,'/',ViconFileName);
    GENEFile = strcat(path,'/',GENEActivFileName);
    FPFile = strcat(path,'/' ,FPFileName);
    %check for existing file
    if exist(ViconFile) == 0
        continue
    elseif exist(GENEFile) == 0
        continue
    elseif exist(FPFile) == 0
        continue
    end
    %reads data
    Vicondata = csvread(ViconFile);
    GENEdata = csvread(GENEFile);
    FPdata = csvread(FPFile);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % CROPPING DATA BY START TIME %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %CORRECT UNTIL HERE
   
    %Vicon Truncation
    ViconStartTime = codebooktrial(1,3);
    ViconFrames = Vicondata(:,1);
    RowStartIndex = 1;
    for i = 1:length(ViconFrames)
        if ViconFrames(i) == ViconStartTime
            RowStartIndex = i;
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
            RowStartIndex = i;
            break
        end
    end
    GENEdata = GENEdata(RowStartIndex:end,:);

    %FP Truncation
    FPStartTime = codebooktrial(1,2);
    class(FPStartTime)
    FPStartTime
    %time = typecast(FPStartTime, 'string')
    %timenew = strsplit(time);
    %timenew = timenew(1,2);
    FPwidth = length(FPdata(1,:));
    FPFrames = FPdata(:,1);
    RowStartIndex = 1;
    for i = 1:length(FPFrames)
        if FPFrames(i) == FPStartTime
            RowStartIndex == i;
            break
        end
    end
    FPdata = FPdata(RowStartIndex:end,:);
    FPheight = length(FPdata(:,1));
    FPnewheight = FPheight/5;
    FPNewData = zeros(FPnewheight,FPwidth);
    FPNewData(1,:) = FPdata(1,:);
    for i = 2:FPnewheight
        FPNewData(i,:) = FPdata((i-1)*5,:);
    end
    %UNCUT synced files
    if (FPNewData(1,1) == FPStartTime)
        disp('FP Works');
    else
        disp('FP Fails');
    end
    if (Vicondata(1,1) == ViconStartTime)
        disp('Vicon Works');
    else
        disp('Vicon Fails');
    end
    if (GENEdata(1,1) == GENEStartTime)
        disp('GENE Works');
    else
        disp('GENE Fails');
    end

    
    %end of trial analysis
end