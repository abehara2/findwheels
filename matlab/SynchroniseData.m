%%%%%%%%%%%%%
% MAIN CODE %
%%%%%%%%%%%%%

%change session number before each script run
session = '1';


%read and parse codebook
codebookpath = strcat('/Users/ashankbehara/desktop/FIND-Wheels/Session',session); 
codebook = csvread(strcat(codebookpath,'/Codebook_Pilot.csv'));
codebookdata = codebook(5:end, 4:7);
totaltrials = length(codebookdata(:,1));
%csvfile = 'final_pilot.csv'; %Parsing pilot csvfile
%[a, b, c, d, e] = textread(csvfile, '%s,%s,%s,%s,%s',"delimiter", ",");
%GENEStartTimes = e;

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
%    GENEdata = csvread(GENEFile);
%    GENEdata = GENEdata(100:end, 2:7);
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
    Vicondata = Vicondata(:,:);


    %GENEActiv Truncation
    [a, b, c, d, e, f, g, h,i, j, k,l] = textread('/Users/ashankbehara/Desktop/FIND-Wheels/Session1/Codebook_Pilot.csv', '%d,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s', "headerlines", 4,"delimiter", ",");
    GENETime = g{trial,1};
    strcat('"', GENETime, '"')
%   [a, b, c, d, e, f, g] = textread(GENEFile, '%s,%s,%s,%s,%s,%s,%s',"delimiter", ",", "headerlines", 100);
    [a, b, c, d, e, f, g] = textread(GENEFile, '%s,%f,%f,%f,%d,%d,%f',"delimiter", ",", "headerlines", 100);
    FinalTime = a;
    GENEdata = horzcat(b,c,d);
    GENETimes = a;
    GENERowStartIndex = 1;
    for i = 1:length(GENETimes)
        timecode = strsplit(GENETimes{i});
        if timecode{1,2} == GENETime
            GENERowStartIndex = i;
            break
        end
    end
    GENEdata = GENEdata(GENERowStartIndex:end,:);
    FinalTime = FinalTime(GENERowStartIndex:end,:);

    %FP Truncation
    FPStartTime = codebooktrial(1,2)
    FPwidth = length(FPdata(1,:));
    FPFrames = FPdata(:,1);
    RowStartIndex = 1;
    for i = 1:length(FPFrames)
        if FPFrames(i) == FPStartTime
            RowStartIndex = i;
            break
        end
    end
    RowStartIndex
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
    accelx = b;
    accelx = b(GENERowStartIndex,1);
    if (GENEdata(1,1) == accelx)
        disp('GENE Works');
    else
        disp('GENE Fails');
    end
    Vicondata = Vicondata(:,3:end);
    FPNewData = FPNewData(:,2:end);
    %TRUNCATING DATA AFTER 6 SECONDS
    truncateTime = min([length(Vicondata(:,1)), length(GENEdata(:,1)),length(FPNewData(:,1))])
    Vicon = Vicondata(1:truncateTime,:);
    GENEActiv = GENEdata(1:truncateTime,:);
    ForcePlate = FPNewData(1:truncateTime,:);
    FinalTime = FinalTime(1:truncateTime,:);
    FinalTime = linspace(0,(truncateTime - 1)*0.001, truncateTime)';
%%%%%%%%%%%%%%%
% FINAL FILES %
%%%%%%%%%%%%%%%


    Vicon;
    GENEActiv;
    ForcePlate;




%%%%%%%%%%%%%%
% FINAL DATA %
%%%%%%%%%%%%%%

    finalData = horzcat(FinalTime,GENEActiv,ForcePlate,Vicon);
    %Data Reads GENE -> FP -> Vicon
    finalFileName = strcat('Session',session,'Trial',trialstring,'.csv');

%%%%%%%%%%%%%%
% WRITE DATA %
%%%%%%%%%%%%%%
    %HEADERS
    [ViconHeader] = textread(ViconFile, "%s", 1, "headerlines", 2, "delimiter", "\n");
    ViconHeader = substr(ViconHeader{:,:},3);

    [FPHeader] = textread(FPFile, "%s", 1, "delimiter", "\n");
    FPHeader = substr(FPHeader{:,:},6);

    [GAHeader] = textread(GENEFile, "%s", 1, "headerlines", 98, "delimiter", "\n");
    GAHeader = substr(GAHeader{:,:},1,-3);

    Header = strcat(GAHeader ,',' ,FPHeader , ',',ViconHeader);

    file = fopen(finalFileName, "w");
    fdisp(file, Header);
    fclose(file);

%    csvwrite(strcat(finalFileName,".tmp"), finalData, "-append", "on");
    csvwrite(strcat(finalFileName,".tmp"), finalData);
    tempfile = strcat(finalFileName,".tmp");
    command = ["cat " tempfile " >> " finalFileName ];
    %strcat("cat", tempfile, " >> ", finalFileName)
    system(command);

%    csvwrite(finalFileName,finalData);

    %end of trial analysis
end