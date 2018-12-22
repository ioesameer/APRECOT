%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%  single engine                                                         %
%  operation ceiling                                                     %
%  fuel and time                                                         %
%  distance                                                              %
%  Effect of weight not taken                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Basic
format long g
clc;
clear;

% Global Variables
global d0 g0
% Import data from library
aircraft;

% CURRENT INPUTS
% W_kg=17000; % input in kg
% W=W_kg*g0; % in newton
% h0_i=4394+1500; % input ft
% h1_i=15000; % input ft, intial
% heightStep=200; % step size
% initialHeight=feet2meter(h0_i); % in m
% finalHeight=feet2meter(h1_i); % in m
% v_i=160; % input climb IAS in kts
% v=knots2meter(v_i); % IAS in m/s
% n_pu=1; % in terms of full power
% dT=0; % ISA+ temperature
% n_load=1; % load factor
% n_flap=0; % flap position, deg

% Import from file
fid= fopen('climbMissionInputs.txt');
dataInputs= textscan(fid,'%s','CommentStyle','%','delimiter','\n');
dataInputs = [dataInputs{:}];
temp=regexp(dataInputs,'\d+(\.)?(\d+)?','match'); %temporary variable
climbInput=str2double([temp{:}]);
fclose(fid);

% Variable Assignation
weight= climbInput(1)*g0
initialHeight=feet2meter(climbInput(2))
finalHeight=feet2meter(climbInput(3))
heightStep=feet2meter(climbInput(4))
inputVelocity=knots2meter(climbInput(5))
powerUsed=climbInput(6)
dT=climbInput(7)
loadFactor=climbInput(8)
flapAngle=climbInput(9)

% CALCULATION

% Time
fun=@(h) 1./(SEP(sqrt(d0./density2(h,dT)).*v,density2(h,dT),n_pu,W,n_flap));
time=integral(fun,initialHeight,finalHeight) % in seconds
%%
% Fuel
h_fuel=initialHeight:heightStep:finalHeight;
d_fuel=density(h_fuel);
v_fuel=cas2tas(v,d_fuel);
Power_fuel=0.932825.*P_max.*(d_fuel./d0).^0.739667;%Bruening 1992
P_mean=mean(Power_fuel);
fuel=c*n_pu*P_mean*time; % in kg

% Distance
h_angle=initialHeight:heightStep:finalHeight;
d_angle=density(h_angle);
v_angle=cas2tas(v,d_angle);
thita_angle=rate_of_climb(d_angle,v_angle,W,n_pu,n_flap);
thita=mean(thita_angle);
v_mean_d=mean(v_angle);
distance=v_mean_d*cos(thita)*time; % in metre

%% OUTPUTS
time_mission=time/60 % in min
fuel_mission=fuel
distance_mission=m2Nm(distance) % in Nm

%% FOR GRAPHS OF VARYING VELOCITY (TAS)

k=1;
for i=50:120
    v2(k)=i; % TAS in m/s
    
    fun=@(h) 1./(SEP(i,density2(h,dT),n_pu,W,n_flap));
    time2(k)=integral(fun,initialHeight,finalHeight); % in seconds
    
    fuel2(k)=c*n_pu*P_mean*time2(k); % in kg
    
    %thita1=rate_of_climb(density2(initialHeight,dT),i,W,n_pu,n_flap);
    %thita2=rate_of_climb(density2(finalHeight,dT),i,W,n_pu,n_flap);
    %thita=(thita1+thita2)/2;
    %distance(k)=i*cos(thita)*time(k);
    h_angle=initialHeight:heightStep:finalHeight;
    thita_angle=rate_of_climb(density2(h_angle,dT),i,W,n_pu,n_flap);
    thita=mean(thita_angle);
    distance2(k)=i*cos(thita)*time2(k); %in metre
    k=k+1;
end

% TAS vs Time for Climb
figure(1)
plot(m2k(v2),time2/60);
xlabel('TAS (kts)');
ylabel('Time for Climb (min)');
title(sprintf('Velocity (TAS) vs Time for Climb = %.0f : %.0f ft for \n Weight = %.0f kg',  h0_i, h1_i, W_kg));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');

% TAS vs Fuel for Climb
figure(2)
plot(m2k(v2),fuel2);
xlabel('TAS (kts)');
ylabel('Fuel (kg)');
title(sprintf('Velocity (TAS) vs Fuel for Climb =%.0f : %.0f ft for \n Weight = %.0f kg',  h0_i, h1_i, W_kg));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');

% TAS vs Time for Climb
figure(3)
plot(m2k(v2),m2Nm(distance2));
xlabel('TAS (kts)');
ylabel('Distance (Nm)');
title(sprintf('Velocity (TAS) vs Distance for Climb  = %.0f : %.0f ft for \n Weight = %.0f kg',  h0_i, h1_i, W_kg));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');