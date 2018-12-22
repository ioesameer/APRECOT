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

%% Import data from library
inputs;

%% CURRENT INPUTS
W_kg=16950; % input in kg
W=W_kg*g0; % in newton
h_cruise_i=15000; % input in ft, final
h_cruise=f2m(h_cruise_i); % in meter
v_cl_i=160; % input IAS in kts
v_climb=k2m(v_cl_i); % IAS in m/s
v_cr_i=200; % input IAS kts
v_cruise=k2m(v_cr_i); % IAS in m/s
n_pu_cr=.9; %acceleration phase
dT=0; %ISA+ temperature
n_load=1; %load factor climb
n_flap=0;%input flap postion, deg
destination_i=127.4; % input in Nm
destination=Nm2m(destination_i); % in meter
distance_total_climb_i=21; % input in Nm
distance_total_climb=Nm2m(distance_total_climb_i);
distance_total_descent_i=22; % input in Nm
distance_total_descent=Nm2m(distance_total_descent_i); % input in Nm

%% FOR ACCELERATION PHASE
d_h_final=density2(h_cruise,dT);
v_t_climb=cas2tas(v_climb,d_h_final);
v_t_cruise=cas2tas(v_cruise,d_h_final);
fun= @(v) v./(1/N2kg(W).*(Thrust_avai(v,d_h_final,n_pu_cr)-.5.*d_h_final.*v.^2.*S.*C_d_flap(0,C_l(W,d_h_final,v))));
distance_acc=integral(fun,v_t_climb,v_t_cruise);
fun= @(v) 1./(1/N2kg(W).*(Thrust_avai(v,d_h_final,n_pu_cr)-.5.*d_h_final.*v.^2.*S.*C_d_flap(0,C_l(W,d_h_final,v))));
time_acc=integral(fun,v_t_climb,v_t_cruise);
power_acc=0.932825.*P_max.*(d_h_final./d0).^0.739667;%Bruening 1992;
fuel_acc=n_pu_cr*power_acc*time_acc*c_n;
W_afteracc=W-fuel_acc;
if time_acc<0;
    display('Error');
    fuel_acc=0;
    time_acc=0;
    distance2acc=0;
end

distance2acc=m2Nm(distance_acc); % in Nm
distance2cruise=destination-(distance_total_climb+distance_total_descent+distance_acc); % in m
distance_cruise=m2Nm(distance2cruise); % in Nm

%% CRUISE CHECKING
if distance2cruise<0 || time_acc<0
    display('Cruise not possible or Error');
    distance2acc=0
    fuel_acc=0
    time_acc=0
    distance_cruise=0
    fuel_used_cruise=0
    time_cruise=0
    W_aftercruise=W_kg;
else
    display('Cruise possible')
    distance2acc % in Nm
    fuel_acc=N2kg(fuel_acc) % in kg
    time_acc=time_acc/60 % in min
    distance_cruise % in Nm
    time_cruise=(distance2cruise/v_t_cruise); % in sec
    power_cruise=Power_req(v_t_cruise,density2(h_cruise,dT),W,0); % n_flap=0
    fuel_used_cruise=power_cruise*time_cruise*c_n; % N
    fuel_cruise=N2kg(fuel_used_cruise) % kg
    time_crusie=time_cruise/60 % in min
    W_aftercruise=N2kg(W_afteracc-fuel_used_cruise) % kg
end

