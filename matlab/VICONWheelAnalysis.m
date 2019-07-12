%% detecting HG impact

clear all
close all
%add current folder in path, it's better to work on local folders than on
%Zdrive, change by subject, T, and device
subjectID='pilot0';
T='000_01';
Device='Vicon';
data = csvread('/Users/ashankbehara/desktop/FIND-Wheels/ViconWheelAnalysis/Aditya_20_Vicon.csv')
VFrame=data(6:end,1);
HG_B2=data(6:end,13:15); %HG_B2 

%gapfill requires MATLAB 2016a and later
%does not work on my version if you have a recent version uncomment the following 4 lines.

%for j=1:3
  %y = fillgaps(HG_B2(:,j),50,1);
  %HG_B2(:,j) = y;
%end


[min_pos,I_min_pos] = min(HG_B2(:,2));
figure
plot(VFrame, HG_B2(:,2)*0.001);

