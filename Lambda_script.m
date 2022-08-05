clc;
clearvars
close all;
set(0,'defaultfigurecolor',[1 1 1])


%%%%%%%%%%%%%%%%%%% MODEL'S CHARACTERISTICS DEFENITION %%%%%%%%%%%%%%%%

Load_mass = 1; % Payload mass (expressed in simulation as a point force applied to the end of segment BC)
Sp_Stiff = 2.5; % Spring Stiffness of revolute joints

% I-PD-regulator сoefficients

KIreg = 350; % I-component's gain сoefficient 
KPDreg = 650; % PD-component's gain сoefficient 
Ki = 5; % I-PD-regulator's integral сoefficient 
Kp = 0.9; % I-PD-regulator's proportional сoefficient 
Kd = 0.1;% I-PD-regulator's derivative сoefficient 

% Elements` size parametrs Determination

x_el = 5; % Taken just because, actually
z_el = 5;
a = 20; % a parametr from the task

% Transmition`s starting state

Dnst = 7800; % Mechanism`s material density (The approximate density of steel)
Starting_deg = 0; % Initial condition of the O joint (Defined in terms of certanity)
Imp_time = 4.7; % Control signal`s period (0.5 + 0.2 + (2 secs = settling time * 2))
Pulse_Wdt = 100*2.5/4.7; % descent time to ascent time ratio

%%%%%%  Simulation of a lambda mechanism %%%%%

SimTime = 15; % Simulation time
Data = sim("Lambda_mech.slx",SimTime);

%%%%%% Plotting %%%%%

% Plotting the X-Y plot of a C point

figure
plot(Data.C_Data.X.Data,Data.C_Data.Z.Data,'LineWidth',3);
xlim([-1.2,1.2]);
title('Trajectoty of the C point in the XY plane')
xlabel('X axis, meters')
xlabel('Y axis, meters')
grid on

% Plotting point C`s velocity and Joint O`s angle graph

figure

subplot(2,1,1)
plot(Data.C_Data.Vx.Time,sqrt(Data.C_Data.Vx.Data.^2+Data.C_Data.Vz.Data.^2),'LineWidth',3);
xlim([0,SimTime])
title('Velocity of the C point (Intertial)')
xlabel('Time, seconds')
xlabel('Velocity, meters/second')
grid on

subplot(2,1,2)
plot(Data.C_Data.O_angle.Time,rad2deg(squeeze(Data.C_Data.O_angle.Data)),'LineWidth',3);
xlim([0,SimTime])
title('Joint O`s angle graphic')
xlabel('Time, seconds')
xlabel('Angle, degrees')
grid on
