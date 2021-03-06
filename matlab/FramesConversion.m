% Enter FPS value of Vicon System
fps = 100

% Reads data from trial on hand
% When running this script from external computer be sure to change the file path and name
% i.e. Everything in orange
data = csvread('/Users/ashankbehara/Desktop/FIND-Wheels/Frames-SecondsParsing/SampleConversion.csv');

%Edits "frame" column of trial assuming all other data sets follow the same format
data(6:end, 1) = data(6:end, 1)/fps;

% Creates new csv file with converted data
% Rename the file based on each trial
csvwrite('trial_.csv', data);

