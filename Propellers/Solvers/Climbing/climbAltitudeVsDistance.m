%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%  single engine                                                         %
%  operation ceiling                                                     %
%  fuel and time                                                         %
%  distance                                                              %
%  Effect of weight not taken                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Basic
format long g
clc;
clear;

% Global Variables
global d0 g0

% Import data from library
aircraft;

% Import from file
fileName='climbAltitudeVsDistanceInputs.txt'
readFromFile % Now read data with readData(n), where n represents the line number of input data.

% Variable Assignation
weight= readData(1)*g0
initialHeight=feet2meter(readData(2))
finalHeight=feet2meter(readData(3))
inputVelocity=knots2meter(readData(4))
powerUsed=readData(5)
dT=readData(6)
loadFactor=readData(7)
flapAngle=readData(8)

%% FOR OPTIMUM ALTITUDE
i=1;  
%%                                                              CALCULATION FOR CLIMB
%% INITIAL VALUE ASSIGNMENT
time_total_climb=0;
fuel_total_climb=0;
distance_total_climb=0;
while 1

    h_final_loop=h_initial+feet2meter(100);
    if h_final_loop>h_final
        h_final_loop=h_final;
    end

    %Time
    fun=@(h) 1./(SEP(v_climb.*sqrt(d0./density2(h,dT)),density2(h,dT),n_pu,W,flapAngle));
    time_climb=integral(fun,h_initial,h_final_loop); %unit seconds
    time_total_climb=time_total_climb+time_climb;
    t(i)=time_total_climb;
    %Fuel
    h_fuel=h_initial:h_final_loop;
    d_fuel=density2(h_fuel,dT);
    d_fuel_mean=mean(d_fuel);
    Power_fuel=0.932825.*P_max.*(d_fuel./d0).^0.739667;%Bruening 1992

    P_mean=mean(Power_fuel);
    fuel_climb=c*n_pu*P_mean*time_climb; %in kg
    fuel_total_climb=fuel_total_climb+fuel_climb;
    f(i)=fuel_total_climb;
    %Distance
    h_angle=h_initial:h_final_loop;
    d_dist=density2(h_angle,dT);
    d_dist_mean=mean(d_dist);
    v_t=v_climb.*sqrt(d0./d_dist);
    v_t_avg=mean(v_t); 
    thita_angle=rate_of_climb(d_dist_mean,v_t_avg,W,n_pu,flapAngle); %velocity is true
    thita=mean(thita_angle);
    distance_climb=v_t_avg*cos(thita)*time_climb; %in metre
    distance_total_climb=distance_total_climb+distance_climb;
    d(i)=distance_total_climb;
    h(i)=h_initial;
    if h_final_loop==h_final
        break;
    end
    h_initial=h_final_loop;
    W=W-fuel_climb*g0;
    i=i+1;
end
%end
figure(1)
plot(m2Nm(d),per1000(meter2feet(h)));
figure(2)
plot(t/60,per1000(meter2feet(h)));
figure(3)
plot(f,per1000(meter2feet(h)));





