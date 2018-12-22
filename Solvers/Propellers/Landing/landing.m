%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
% Based on Anderson's book                                               %
% Brake coefficient unknown                                              %
% Reverse power has different efficiency                                 %
% Free roll                                                              %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Basic
format long g
clc;
clear;

%% Import data from library
inputs;
airport;
coef_fric;


%% CURRENT INPUT
Temp=20;%ambient air temp
n_flap_land=35;% input flap position, deg
W_kg=W_mlw; % input in kg
W_land=W_kg; % can use W_kg
n_pu_re=0; %in decimal terms compared to full power
approach_angle=3; %in degree  
v_wind=0;
wind_angle=50;%in degree


%% DENSITY CALCULATION
[d1,Temp1]=density(h_elev);
Temp=Temp+273.16;
d=d1*Temp1/Temp;


%% APPROACH VELOCITIES

v_a= .95*1.3*v_stall(n_flap_land,d,W_land,1); %v_stall(n_flap,d,W,n_load)
v_f= .95*1.23*v_stall(n_flap_land,d,W_land,1); %.95 because it is reference stall speed
v_td= .95*1.15*v_stall(n_flap_land,d,W_land,1);

%% WIND EFFECT ON ANGLE
v_w=v_wind*cosd(wind_angle);
thita=approach_angle*(1-v_w/v_a);

%% PHASE ON AIR
C_l_app=2*W_land/(d*S*v_a^2);
C_d=C_d_flap_ground(n_flap_land,C_l_app,W_land);
D=.5*d.*v_a.^2*S*C_d;
T_required=D-W_land*sind(thita);
P_required=T_required*v_a;

Radius=(v_f^2)/(0.2*g); %radius of flare
h_f=Radius*(1-cosd(thita)); %height of flare
S_a=(15.24-h_f)/tand(thita); %approach distance
S_f=Radius*sind(thita); %flare distance
t_air=(S_a+S_f)/v_f; %time till touchdown

%% WIND EFFECT  AIR(ESDU EG 5/1 1972) (Austyn Mair)
v_w=v_wind*cosd(wind_angle);
v_m=v_f;
g_w=(v_m-v_w)/v_m;
S_a=S_a*g_w;
S_f=S_f*g_w;
t_air=t_air*sqrt(g_w); %for time  square root is used


%% FREE ROLL
S_fr=v_td; %3*V_td for large aircraft fr= free roll

%% GROUND RUN
V_min=.01;
V_max=v_td;
%Distance by integration
fun=@(v) v./((g./W_land).*((Power_avai(v,d,n_pu_re)./v)+(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_land,C_l_ground,W_land))+10*u_r.*(W_land-(.5.*d.*v.^2.*S.*C_l_ground)))+g*sind(runway_slope));
S_g= integral(fun,V_min,V_max);
%Time by integration
fun1=@(v) 1./((g./W_land).*((Power_avai(v,d,n_pu_re)./v)+(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_land,C_l_ground,W_land))+10*u_r.*(W_land-(.5.*d.*v.^2.*S.*C_l_ground)))+g*sind(runway_slope));
t_g=integral(fun1,V_min,V_max)

%% WIND EFFECT (ESDU EG 5/1 1972) (Austyn Mair)
v_w=v_wind*cosd(wind_angle);
v_m=v_td*(.5+.27*(v_w/v_td));
g_w=(v_m-v_w)/v_m;
S_g=S_g*g_w;
t_g=t_g*sqrt(g_w); %for time  square root is used


%% RESULTS
%Distances
S_land= S_a+S_f+S_fr+S_g
S_destination=S_land/.6
S_alternate=S_land/.7
%Total time
time=t_air+1+t_g %1 second for free roll