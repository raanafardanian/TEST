%% Clear workspace and command window
clc
clear all
close all
%% Open simulink file
open_system('Assignment')

%% Variables defination
R=0.03;   %Armature resistance [ 0.03 Ω]
L=2.5e-3 ;   %Armature inductance [2.5 mH]
Kb=0.35;  %Back-emf constant [0.35 V.s/rad]
J=0.5*10^-3 ; %Moment of inertia of the shaft and load [0.5 * 10-3 Kg.m2].
Kt=0.9 ;  %Motor's torque constant [0.9 Nm/A]
b=0.24 ;  %Bearing's friction coefficient [0.24 Nm.s/rad]
i=0.2 ;   %i = transmission ratio [0.2]
r=0.3 ;   %dynamic wheel radius [0.3 m]
W=45  ;   %rolling resistance [45 kg.m/s2]
X=0.46;   %[kg/m]
Y=300  ;  %mass[kg]
Z=3000 ;  %weight [3000 N]
%%Space state Variables Defination
A=[-R/L -Kb/L;Kt/J -b/J];
B=[1/L 0;0 -1/J];
C=[1 0;0 1];
D=[0 0;0 0];
%%Import Validation fine and define as Input to simulink
Data=xlsread('InputOutputData');
%Rename columns and define Input for simin
time=Data(:,1);                    %Define time from Validation Excel file
Voltage_valid=Data(:,2);           %Define Voltage from Validation Excel file
Velocity_valid=Data(:,3);          %Define Velocity from Validation Excel file
slope_valid=Data(:,4);             %Define Slope from Validation Excel file
Current_valid=Data(:,5);           %Define Current from Validation Excel file
Omega_valid=Data(:,6);             %Define Omega from Validation Excel file
Voltage_Input_test=[time,Voltage_valid]; %Define Voltage as input to simulink
Velocity_Input_test=[time,Velocity_valid]; %Define Velocity as input to simulink
Slope_Input_test=[time,slope_valid]; %Define Slope as input to simulink
%% Run Scenario 1 Simulink
sim_time=0.4;       %Simulation Time
sim('Assignment')
%%Plotting the Inputs 
figure('Name','Scenario1','Numbertitle','off')
subplot(2,1,1);
%plot(tout,Voltage,'r');hold on;grid on;
plot(tout,Omega,'g');
title('Input')
legend('Omega')
xlabel('Time [s]');
ylabel('Omega [rad/s]')
%%Plotting the Output
subplot(2,1,2);
%plot(tout,Voltage,'k');hold on;grid on;
plot(tout,Current,'b');
title('OutPut Result')
legend('Current')
xlabel('Time [s]');
ylabel('Current [A]')
%% Run Scenario 2 Simulink
sim_time=30;           %Simulation Time
sim('Assignment')
%%Plotting the Inputs
figure('Name','Scenario2','Numbertitle','off')
subplot(3,1,1);
plot(tout,Voltage,'r',tout,Velocity,'g');hold on;grid on;
title('Input')
legend('Voltage','Velocity')
xlabel('Time [s]');
%%Plotting the Output
subplot(3,1,2);
plot(tout,Omega,'k');hold on;grid on;
title('Omega')
legend('Angular Velocity','Current')
xlabel('Time [s]');
ylabel('Omega [rad/s]')
subplot(3,1,3)
plot(tout,Current,'b')
title('Current')
legend('Current')
xlabel('Time [s]');
ylabel('Current [A]')
%% Run Scenario 3 Simulink
sim_time=50;     %Simulation Time
sim('Assignment')
%%Plotting the Inputs
figure('Name','Scenario3','Numbertitle','off')
subplot(2,1,1);
plot(tout,Voltage1,'r');hold on;grid on;
plot(tout,VelocityS3,'g');
title('Input')
legend('Voltage','Velocity')
xlabel('Time [s]');
%Plotting the Outputs
subplot(2,1,2);
plot(tout,OmegaS3,'k');hold on;grid on;
plot(tout,CurrentS3,'b');
title('OutPut Result')
legend('Angular Velocity','Current')
xlabel('Time [s]');
%% Compare Validation and simulink output
%Run Simulation
sim_time=10;  %Simulation time
sim('Assignment')
%Plotting the Current, comparison between excel file and simulink result
figure('Name','Validation','Numbertitle','off')
subplot(2,1,1)
plot(tout,Validation(:,1),'*',time,Current_valid,'y');hold on;grid on;
title('Motor Current comparison with Validation file')
legend('Simulink','Validation file output')
xlabel('Time [s]');
ylabel('Current [a]')
%Plotting the Omega, comparison between excel file and simulink result
subplot(2,1,2);
plot(tout,Validation(:,2),'*',time,Omega_valid,'y');hold on;grid on;
title('Angular Velocity comparison with Validation file')
legend('Simulink','Validation file output')
xlabel('Time [s]');
ylabel('Omega [rad/s]')
%%Plot output of system and validation file without Input consideration
figure('Name','Validation without Input consideration','Numbertitle','off')
subplot(2,1,1)
plot(tout,Omega,'r',time,Omega_valid,'b')
legend('Omega as system output','Omega in validation file')
xlabel('Time [s]');
ylabel('Current [A]')
subplot(2,1,2)
plot(tout,Current,'r',time,Current_valid,'b')
legend('Current as system output','Current in validation file')
xlabel('Time [s]');
ylabel('Current [A]')
%Plotting  Input of Validation file
figure('Name','system and validation file Input comparison','Numbertitle','off')
plot(tout,Velocity,'r',time,Velocity_valid,'b')
legend('Velocity Input of system','Velocity of validation file')
xlabel('Time [s]');
ylabel('V [m/s]')

%% Compate DE,TF and Statespace
%Plotting the current from DE,TF and SS calculation
figure('Name','DE-TF-SS','Numbertitle','off')
subplot(2,1,1)
plot(tout,StateSpace(:,1),'b--o',tout,Current,'g',tout,CurrentTF,'c*');hold on;grid on;
title('Motor Current comparison result with SS-DE-TF')
legend('State Space','DE','TF')
xlabel('Time [s]');
ylabel('Current [a]')
%Plotting the Omega from DE,TF and SS calculation
subplot(2,1,2);
plot(tout,StateSpace(:,2),'b--o',tout,Omega,'g',tout,OmegaTF,'c*');hold on;grid on;
title('Angular Velocity comparison result with SS-DE-TF')
legend('State Space','DE','TF')
xlabel('Time [s]');
ylabel('Omega [rad/s]')

%% Define various values for variables (I,j,b) 
%%Different value of I

I=(0.2)*.9:(0.2)*0.1:(0.2)*1.1;
n=length(I);
figure('Name','Different Value of J,b,i','Numbertitle','off')

for p=1:1:n
    i=I(p);
    %J=0.5*10^-3;
    %b=0.24 ; 
    %i=0.2;
    sim_time=5;
    sim('Assignment')
    
    subplot(3,2,1)
    plot(tout,CurrentTF);hold on;grid on;
    title('Current with Different I values')
    legend(strcat('i=',num2str(I')));
    xlabel('Time [s]');
    ylabel('Current [a]')
    subplot(3,2,2);
    plot(tout,OmegaTF);hold on;grid on;
    title('Angular Velocity with Different I values')
    legend(strcat('i=',num2str(I')));
    xlabel('Time [s]');
    ylabel('Omega [rad/s]')
    
    
end  


%%Different value of J
j=(0.5*10^-3)*.9:(0.5*10^-3)*0.1:(0.5*10^-3)*1.1;
n=length(j);

for p=1:1:n
    J=j(p);
    %J=0.5*10^-3;
    %b=0.24 ; 
    i=0.2;
    sim_time=5;
    sim('Assignment')
    subplot(3,2,3)
    plot(tout,CurrentTF);hold on;grid on;
    title('Current with Different J values')
    legend(strcat('J=',num2str(j')));
    xlabel('Time [s]');
    ylabel('Current [a]')
    subplot(3,2,4);
    plot(tout,OmegaTF);hold on;grid on;
    title('Angular Velocity with Different J values')
    legend(strcat('J=',num2str(j')));
    xlabel('Time [s]');
    ylabel('Omega [rad/s]')
    
    
end 


%%Different value of b
bb=(0.24)*.9:(0.24)*0.1:(0.24)*1.1;
n=length(bb);
for p=1:1:n
    b=bb(p);
    J=0.5*10^-3;
    %b=0.24 ; 
    %i=0.2;
    sim_time=5;
    sim('Assignment')
    
    subplot(3,2,5)
    plot(tout,CurrentTF);hold on;grid on;
    title('Current with Different b values')
    legend(strcat('b=',num2str(bb')));
    
    xlabel('Time [s]');
    ylabel('Current [a]')
    subplot(3,2,6);
    plot(tout,OmegaTF);hold on;grid on;
    title('Angular Velocity with Different b values')
    legend(strcat('b=',num2str(bb')));
    xlabel('Time [s]');
    ylabel('Omega [rad/s]')
    
end 


