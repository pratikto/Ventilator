%% Start of script
addpath('peakDetection');           % include library
close all;                          % close all figures
clear;                              % clear all variables
clc;                                % clear the command terminal

##import sensor data
FlowSensor = csvread ("FlowSensor.csv");
PressureSensor = csvread ("PressureSensor.csv");

##scale Flow sensor data to 0.0 - 5.0
Flow = zeros(length(FlowSensor),1);
tFlow = zeros(length(FlowSensor),1);
maxFlowSensor = max(FlowSensor);
minFlowSensor = min(FlowSensor);
for i = 1:length(FlowSensor)
  Flow(i) = (FlowSensor(i)-minFlowSensor)/(maxFlowSensor-minFlowSensor)*5;
  tFlow(i) = i/30;
endfor

##scale Pressure sensor data to 0.0 - 5.0
Pressure = zeros(length(PressureSensor),1);
tPressure = zeros(length(PressureSensor),1);
maxPressureSensor = max(PressureSensor);
minPressureSensor = min(PressureSensor);
for i = 1:length(PressureSensor)
  Pressure(i) = (PressureSensor(i)-minPressureSensor)/(maxPressureSensor-minPressureSensor)*5;
  tPressure(i) = i/30;
endfor

##Export sensor conversion
csvwrite("Flow.csv", Flow);
csvwrite("Pressure.csv", Pressure);

####Plot Sensor data and Sensor conversion data
##figure('Name', 'Sensor Data');
##axis(1) = subplot(2,2,1);
##hold on;
##plot(FlowSensor, 'r');
####legend('Flow Sensor');
##xlabel('Count');
##ylabel('Flow');
##title('Flow Sensor');
##hold off;
##axis(2) = subplot(2,2,3);
##hold on;
##plot(Flow, 'b');
####legend('Flow Sensor Conversion');
##xlabel('Count');
##ylabel('Flow');
##title('Flow Sensor Conversion');
##hold off;
##axis(3) = subplot(2,2,2);
##hold on;
##plot(PressureSensor, 'r');
####legend('Pressure Sensor');
##xlabel('Count');
##ylabel('Pressure');
##title('Pressure Sensor');
##hold off;
##axis(4) = subplot(2,2,4);
##hold on;
##plot(Pressure, 'b');
####legend('Pressure Sensor Conversion');
##xlabel('Count');
##ylabel('Pressure');
##title('Pressure Sensor Conversion');
##hold off;

% Peak detection algorithm Settings
FlowLag = 100;
FlowThreshold = 3.8;
FlowInfluence = 0.01;
PressureLag = 10;
PressureThreshold = 4;
PressureInfluence = 0.1;

% Detect peak flow data
[_FlowSignals,FlowAvg,FlowDev] = PeakDetection(Flow,FlowLag,FlowThreshold,FlowInfluence);

FlowSignals = zeros(length(_FlowSignals),1);
FlowSignals = _FlowSignals;
PastState = 0;
CurrentState = 0;
PastCount = 0;
CurrentCount = 0;
for i = 2:length(FlowSignals)
  if ((FlowSignals(i-1) == 1) && (FlowSignals(i) == 0))
    CurrentState = 1;
    CurrentCount = i;
  elseif ((FlowSignals(i-1) == -1) && (FlowSignals(i) == 0))
    CurrentState = -1;
    CurrentCount = i;
  end
  if FlowSignals(i-1) == FlowSignals(i)
    FlowSignals(i-1) = 0;
  end;
##  if CurrentState == PastState
##    FlowSignals(PastCount) = 0;
##  end
  PastState = CurrentState;
  PastCount = CurrentCount;
endfor;

figure('Name', "Flow Peak Detection");
axis(1) = subplot(2,2,1); 
hold on;
x = 1:length(Flow); ix = FlowLag+1:length(Flow);
area(x(ix),FlowAvg(ix)+FlowThreshold*FlowDev(ix),'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
area(x(ix),FlowAvg(ix)-FlowThreshold*FlowDev(ix),'FaceColor',[1 1 1],'EdgeColor','none');
plot(x(ix),FlowAvg(ix),'LineWidth',1,'Color','cyan','LineWidth',1.5);
plot(x(ix),FlowAvg(ix)+FlowThreshold*FlowDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(x(ix),FlowAvg(ix)-FlowThreshold*FlowDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(1:length(Flow),Flow,'b');
xlabel('Count');
ylabel('Flow');
axis(3) = subplot(2,2,3);
hold on;
stairs(FlowSignals*5,'r','LineWidth',1.5); 
stairs(_FlowSignals*5,'y','LineWidth',1.5); 
##legend("FlowSignals", "_FlowSignals");
xlabel('Count');
ylabel('Flow');
axis(4) = subplot(2,2,[2,4]); 
hold on;
x = 1:length(Flow); ix = FlowLag+1:length(Flow);
##area(x(ix),FlowAvg(ix)+FlowThreshold*FlowDev(ix),'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
##area(x(ix),FlowAvg(ix)-FlowThreshold*FlowDev(ix),'FaceColor',[1 1 1],'EdgeColor','none');
##plot(x(ix),FlowAvg(ix),'LineWidth',1,'Color','cyan','LineWidth',1.5);
##plot(x(ix),FlowAvg(ix)+FlowThreshold*FlowDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
##plot(x(ix),FlowAvg(ix)-FlowThreshold*FlowDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(1:length(Flow),Flow,'b');
stairs(_FlowSignals*5,'y','LineWidth',1.5);
stairs(FlowSignals*5,'r','LineWidth',1.5); 
xlabel('Count');
ylabel('Flow');

figure('Name', "Flow Peak Detection");
##subplot(2,1,1); 
hold on;
x = 1:length(Flow); ix = FlowLag+1:length(Flow);
area(x(ix),FlowAvg(ix)+FlowThreshold*FlowDev(ix),'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
area(x(ix),FlowAvg(ix)-FlowThreshold*FlowDev(ix),'FaceColor',[1 1 1],'EdgeColor','none');
plot(x(ix),FlowAvg(ix),'LineWidth',1,'Color','cyan','LineWidth',1.5);
plot(x(ix),FlowAvg(ix)+FlowThreshold*FlowDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(x(ix),FlowAvg(ix)-FlowThreshold*FlowDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(1:length(Flow),Flow,'b');
##subplot(2,1,2);
stairs(_FlowSignals*5,'y','LineWidth',1.5); 
stairs(FlowSignals*5,'r','LineWidth',1.5); 
##ylim([-1.5 1.5]);

% Detect peak Pressure data
[_PressureSignals,PressureAvg,PressureDev] = PeakDetection(Pressure,PressureLag,PressureThreshold,PressureInfluence);

PressureSignals = zeros(length(_PressureSignals),1);
PressureSignals = zeros(length(_PressureSignals),1);
PressureSignals = _PressureSignals;
PastState = 0;
CurrentState = 0;
for i = 2:length(PressureSignals)
  if ((PressureSignals(i-1) == 1) && (PressureSignals(i) == 0))
    CurrentState = 1;
  elseif ((PressureSignals(i-1) == -1) && (PressureSignals(i) == 0))
    CurrentState = -1;
  end
##  if ((PressureSignals(i-1) == PressureSignals(i)) || (CurrentState == PastState))
  if PressureSignals(i-1) == PressureSignals(i)
    PressureSignals(i-1) = 0;
  end;
  PastState = CurrentState;
endfor;

figure('Name', "Pressure Peak Detection");
axis(1) = subplot(2,2,1); 
hold on;
x = 1:length(Pressure); ix = PressureLag+1:length(Pressure);
area(x(ix),PressureAvg(ix)+PressureThreshold*PressureDev(ix),'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
area(x(ix),PressureAvg(ix)-PressureThreshold*PressureDev(ix),'FaceColor',[1 1 1],'EdgeColor','none');
plot(x(ix),PressureAvg(ix),'LineWidth',1,'Color','cyan','LineWidth',1.5);
plot(x(ix),PressureAvg(ix)+PressureThreshold*PressureDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(x(ix),PressureAvg(ix)-PressureThreshold*PressureDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(1:length(Pressure),Pressure,'b');
xlabel('Count');
ylabel('Pressure');
axis(3) = subplot(2,2,3);
hold on;
stairs(PressureSignals*5,'r','LineWidth',1.5); 
stairs(_PressureSignals*5,'y','LineWidth',1.5); 
##legend("PressureSignals", "_PressureSignals");
xlabel('Count');
ylabel('Pressure');
axis(4) = subplot(2,2,[2,4]); 
hold on;
x = 1:length(Pressure); ix = PressureLag+1:length(Pressure);
##area(x(ix),PressureAvg(ix)+PressureThreshold*PressureDev(ix),'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
##area(x(ix),PressureAvg(ix)-PressureThreshold*PressureDev(ix),'FaceColor',[1 1 1],'EdgeColor','none');
##plot(x(ix),PressureAvg(ix),'LineWidth',1,'Color','cyan','LineWidth',1.5);
##plot(x(ix),PressureAvg(ix)+PressureThreshold*PressureDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
##plot(x(ix),PressureAvg(ix)-PressureThreshold*PressureDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(1:length(Pressure),Pressure,'b');
stairs(_PressureSignals*5,'y','LineWidth',1.5);
stairs(PressureSignals*5,'r','LineWidth',1.5); 
xlabel('Count');
ylabel('Pressure');

figure('Name', "Pressure Peak Detection");
##subplot(2,1,1); 
hold on;
x = 1:length(Pressure); ix = PressureLag+1:length(Pressure);
area(x(ix),PressureAvg(ix)+PressureThreshold*PressureDev(ix),'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
area(x(ix),PressureAvg(ix)-PressureThreshold*PressureDev(ix),'FaceColor',[1 1 1],'EdgeColor','none');
plot(x(ix),PressureAvg(ix),'LineWidth',1,'Color','cyan','LineWidth',1.5);
plot(x(ix),PressureAvg(ix)+PressureThreshold*PressureDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(x(ix),PressureAvg(ix)-PressureThreshold*PressureDev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(1:length(Pressure),Pressure,'b');
##subplot(2,1,2);
stairs(_PressureSignals*5,'y','LineWidth',1.5); 
stairs(PressureSignals*5,'r','LineWidth',1.5); 
##ylim([-1.5 1.5]);
