%FP kinetic analysis
%Ashank Behara
subjectID='pilot0';
T='000_01';
data = readmatrix('/Users/ashankbehara/Desktop/FIND-Wheels/ForcePlate/SampleForcePlate.csv');
Force_back = data(2:end,2)';
Force_front = data(2:end,3)';
max_Force_back = max(Force_back);
max_Force_front = max(Force_front);
min_Force_back = min(Force_back);
min_Force_front = min(Force_front);
maxY = max([max_Force_back, max_Force_front]) + 100;
minY = min([min_Force_back, min_Force_front]) - 300;
%Back Plate
figure
plottitle=['Forceplate Force (N): Trial ' T(5:6) ];
title(plottitle,'fontsize',12)
ylim([minY maxY])
xlabel('Time','fontsize', 12);
ylabel('Vertical force(N)','fontsize', 12);
set(gca,'fontsize',12)
plot(Force_back,'-r');
hold on
%Front Plate
plot(Force_front, 'b');
hold off
%pause(1)


