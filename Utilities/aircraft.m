%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%   idle power in percentage                                             %
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
format long g
constants;
%% declaration of variable as global
global S Cd0 k b AR flapType flapChordToWingChord flapAreaToWingArea  flapSpanToWingSpan C_l_ground tyrePressure
global fuselageDiameterToWingDiameter lambda wingHeight 
global angle_flapPosition0 angle_flapPosition1 angle_flapPosition2 angle_flapPosition3
global ClMax0 ClMax1 ClMax2 ClMax3
global P_max

%% WEIGHT (in kg)
%m_ramp=18770;
m_mtow=18600;
%m_empty=11250;
m_mlw=18300;
%m_payload_max=5450;
%m_fuel_max=4500;

%% WEIGHT CALCULATION(converting to N)
%W_ramp=m_ramp*g;
W_mtow=m_mtow*g;
%W_empty=m_empty*g;
W_mlw=m_mlw*g;
%W_payload_max=m_payload_max*g;
%W_fuel_max=m_fuel_max*g;


%% AERODYNAMICS

S =54.5;
Cd0=.026;
k=.03934;
wingHeight=3; %metre
b=24.57; %metre
AR=11.08;
C_l_ground=.1;
ClMax0=1.6906; %(numbers represent flap position)
ClMax1=2.14;
ClMax2=2.4824;
ClMax3=2.6803;
angle_flapPosition0=0; % the values below are the angular position of the flap
angle_flapPosition1=15;
angle_flapPosition2=30;
angle_flapPosition3=35;

%following variables are needed for flap
flapType='singleSlotted'; %'plain', 'split', 'singleSlotted', 'doubleSlotted' are the options
flapChordToWingChord=.2; %ratio of flap chord to chord
flapAreaToWingArea=.7; %ratio of area influenced by flap to total wing area 
fuselageDiameterToWingDiameter=.2; %ratio of diameter of fuselage to wingspan bfi_b
flapSpanToWingSpan=.8; %ratio of distance between flap tips to wingspan  bfo_b 
lambda=0; %sweep angle at c/4 chord

tyrePressure=110; %unit is psi avg value=110

%% PROPULSION (watt)
P_max_in=1790000; 
P_to_both=1611360;
P_to_single=1790000;
P_con=1790000;
P_climb=1611360;
P_cruise=1590472;
c_i=0.298; % input specific fuel consumption in kg/KW.h
c=c_i/(1000*3600); % in kg/(Ws)
c_n=c*g0; % in N/Ws
propellerDiameter=3.93;
gearRatio=1;
maximumRPM=1200; % input RPM
maximumRPS=maximumRPM/60; % in pres

%% Propulsion Calculation (making dimensionless)
P_max=2*P_max_in;
n_pu_to_two=2*P_to_both/P_max; % input
n_pu_to_one=P_to_single/P_max ; % input
n_pu_maxcon_two=2*P_con/P_max;
n_pu_maxcon_one=n_pu_maxcon_two/2;
n_pu_maxclimb_two=2*P_climb/P_max;
n_pu_maxclimb_one=n_pu_maxclimb_two/2;
n_pu_maxcruise_two=2*P_cruise/P_max;
n_pu_maxcruise_one=n_pu_maxcruise_two/2;

%% INPUT CALCULATION
E_m=1/sqrt(4*k*Cd0);
C_l_tmin=sqrt(Cd0/k); % for Minimum Thrust, (C_l/C_d)max, Max_range_prop, Max_end_jet
C_l_pmin=sqrt(3)*C_l_tmin; % for Minimum Power, (C_l^(3/2)/C_D)max, Max_end_prop, Max_rate_of_sink
C_l_cmin=sqrt(1/3)*C_l_tmin; % for Minimum Fuel Consumption per unit Velocity, (C_l^(1/2)/C_D)max, Max_range_jet

