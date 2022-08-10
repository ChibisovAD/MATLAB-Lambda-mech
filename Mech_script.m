clc;
clearvars
close all;
set(0,'defaultfigurecolor',[1 1 1])


%%%%%%%%%%%%%%%%%%% MODEL'S CHARACTERISTICS DEFENITION %%%%%%%%%%%%%%%%

Vmax = 12;
[angles,hardnessmult] = ModeSwitch('Soft') % Control`s mode
Load_mass = 1; % Payload mass (expressed in simulation as a point force applied to the end of segment BC)
Sp_Stiff = 2.5; % Spring Stiffness of revolute joints

% Speed PI-regulator сoefficients

S_KPIreg = 1; % PI-regulator's gain сoefficient
S_Ki = 200; % PI-regulator's integral сoefficient
S_Kp = 5.5; % PI-regulator's proportional сoefficient

%%%% Angle I-PD-regulator сoefficients %%%%

% Raise control I-PD

A_KIreg_Raise = 350; % I-component's gain сoefficient
A_KPDreg_Raise = 1.25; % PD-component's gain сoefficient
A_Ki_Raise = 1.5; % I-PD-regulator's integral сoefficient
A_Kp_Raise = 0.5; % I-PD-regulator's proportional сoefficient
A_Kd_Raise = 0.025;% I-PD-regulator's derivative сoefficient

% Decent control I-PD

A_KIreg_Decent = 350; % I-component's gain сoefficient
A_KPDreg_Decent = 1.25; % PD-component's gain сoefficient
A_Ki_Decent = 1.5; % I-PD-regulator's integral сoefficient
A_Kp_Decent = 0.5; % I-PD-regulator's proportional сoefficient
A_Kd_Decent = 0.025;% I-PD-regulator's derivative сoefficient

%Elements` size parametrs Determination

x_el = 5; % Taken just because, actually
z_el = 5;
a = 20; % a parametr from the task

%Transmition`s starting state

Desired_Speed = (Vmax*1.05)*hardnessmult; % Joint O`s desired speed
Dnst = 7800; % Mechanism`s material density (The approximate density of steel)
Starting_deg = 0; % Initial condition of the O joint (Defined in terms of certanity)
Imp_time = 10; % Control signal`s period (5 + 2 + (2 secs = settling time * 2))
Pulse_Wdt = 50; % descent time to ascent time ratio

%%%%%%  Simulation of a lambda mechanism %%%%%

SimTime = 25; % Simulation time
Data = sim("mech2.slx",SimTime);

%%%%%% Plotting %%%%%

% Plotting the X-Y plot of a C point

figure
plot(Data.C_Data.X.Data,Data.C_Data.Z.Data,'LineWidth',3);
xlim([-1.2,1.2]);
title('Trajectoty of the C point in the XY plane')
xlabel('X axis, meters')
xlabel('Y axis, meters')
grid on

% Plotting the Joint O`s angle graph

figure
plot(Data.C_Data.O_angle.Time,rad2deg(squeeze(Data.C_Data.O_angle.Data)),'LineWidth',2);
xlim([0,SimTime])
title('Joint O`s angle graphic')
xlabel('Time, seconds')
xlabel('Angle, degrees')
grid on

% Plotting point C`s velocity and acceleration

figure

subplot(2,1,1)
plot(Data.C_Data.Vx.Time,sqrt(Data.C_Data.Vx.Data.^2+Data.C_Data.Vz.Data.^2),'LineWidth',2);
xlim([0,SimTime])
title('Velocity of the C point (Intertial)')
xlabel('Time, seconds')
xlabel('Velocity, meters/second')
grid on

subplot(2,1,2)
plot(Data.C_Data.ax.Time,sqrt(Data.C_Data.ax.Data.^2+Data.C_Data.az.Data.^2),'LineWidth',2);
xlim([0,SimTime])
title('Acceleartion of the C point (Intertial)')
xlabel('Time, seconds')
xlabel('Acceleartion, meters/second')
grid on

%%%%% Mode switch function %%%%%

function [angles,hardnessmult] = ModeSwitch(type_name)
switch type_name
    case 'Soft'
        angles = [11*pi/12, pi/10];
        hardnessmult = 0.2;
    case 'Medium'
        angles = [5*pi/6, pi/6];
        hardnessmult = 0.5;
    case 'Hard'
        angles = [3*pi/4, pi/4];
        hardnessmult = 1;
end
end