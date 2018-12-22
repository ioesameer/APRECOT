%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
% based on Anderson's book                                               %
% density assumed to have linear relation with temperature               %
%                                                                        %
% wet runway, icy runway not done                                        %
% ass velocities are TAS                                                 %
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
W_kg=18600; % input in kg
W_to=W_kg*g0; % in newton
v2_ratio_i=1.13; % input from v2_ratio optimization
n_pu_to=.9; %in terms of power by both engines
n_pu_to_single=.5;%n_pu_to1 in dropdown menu
n_flap_to=15; % input flap position for take-off, deg
n_pu_re=0; %in decimal terms compared to full power
v_wind=0;
wind_angle=0;%in degree
Temp=15;%ambient air temp celcius
n_r=200; %iterationns for v_cr_ratio
n_clmax=0.937; %fraction of maximum coefficient of lift used for the configuration


%% DENSITY V_R, V_SO, v_cr AND V_2 CALCULATION
[d1,Temp1]=density(h_elev);
Temp=Temp+273.16;
d=d1*Temp1/Temp;
v_sr=v_stall(n_flap_to,d,W_to,1);
v_r=1.1.*v_sr; % TAS in m/s
v2=v2_ratio_i.*v_sr; % TAS in m/s

%%                                                                   BOTH ENGINES

coef_fric; %calling script to find u_r

%For Ground Roll
%distance
v_min=.01;
v_max=v_r;
fun=@(v) v./((g./W_to).*((Power_avai(v,d,n_pu_to)./v)-(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))-u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))-g*sind(runway_slope));
S_g= integral(fun,v_min,v_max); % till Rotation
S_g=S_g+(v_r*1); % till Lift-off assuming 1 second interval acc. to Anderson Eg 6.93
%time
v_min=.1;
v_max=v_r;
fun=@(v) 1./((g./W_to).*((Power_avai(v,d,n_pu_to)./v)-(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))-u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))-g*sind(runway_slope));
t_g= integral(fun,v_min,v_max);
t_g=t_g+1; % till Lift-off assuming 1 second interval acc. to Anderson Eg 6.93

%WIND EFFECT (ESDU EG 5/1 1972) (Austyn Mair)
v_w=v_wind*cosd(wind_angle);
v_m=v_r*(.5+.27*(v_w/v_r)); %mean velocity of wind
g_w=(v_m-v_w)/v_m;
S_g=S_g*g_w;
t_g=t_g*sqrt(g_w); %for time  square root is used


%For airborne
%distance
v_avg=(v_r+v2)/2;
T=Thrust_avai(v_avg,d,n_pu_to);
D=.5*d*v_avg^2*S*C_d_flap_ground(n_flap_to,n_clmax*C_l_max_flap(n_flap_to),W_to); % drag due to landing gear
thita1=asin(T/W_to-D/W_to);
S_a=10.5/tan(thita1);
%time
S_a_temp=10.5/sin(thita1);
t_a=S_a_temp/v_avg;

%Wind Effect
v_m=v_avg;
g_w=(v_m-v_w)/v_m;
S_a=S_a*g_w;
t_a=t_a*sqrt(g_w);

%Output
distance_both=(S_g+S_a) % in meter
time_both=t_g+t_a % in meter
angle_both=thita1*180/pi % in deg

%%                                                              SINGLE ENGINE
i=1;
for v_cr_ratio_loop = linspace(0.8,1,n_r)
    v_cr=v_cr_ratio_loop.*v_r; 

       %Both Engines Running

    %for distance
    fun=@(v) v./((g./W_to).*((Power_avai(v,d,n_pu_to)./v)-(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))-u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))-g*sind(runway_slope));
    S_g1= integral(fun,0.01,v_cr);

    %for time
    fun=@(v) 1./((g./W_to).*((Power_avai(v,d,n_pu_to)./v)-(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))-u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))-g*sind(runway_slope));
    t_g1= integral(fun,0.01,v_cr);

    %WIND EFFECT (ESDU EG 5/1 1972) (Austyn Mair)
    v_w=v_wind*cosd(wind_angle);
    v_m=v_cr*(.5+.27*(v_w/v_cr)); %mean velocity of wind
    g_w=(v_m-v_w)/v_m;
    S_g1=S_g1*g_w;
    t_g1=t_g1*sqrt(g_w); 

        %Engine Fails

    %for distance
    fun=@(v) v./((g./W_to).*((Power_avai(v,d,n_pu_to_single)./v)-(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))-u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))-g*sind(runway_slope));
    S_g2=integral(fun,v_cr,v_r);
    S_g2=S_g2+(v_r*1); % till Lift-off assuming 1 second interval acc. to Anderson Eg 6.93
    %for time
    fun=@(v) 1./((g./W_to).*((Power_avai(v,d,n_pu_to_single)./v)-(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))-u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))-g*sind(runway_slope));
    t_g2=integral(fun,v_cr,v_r);
    t_g2=t_g2+1; % till Lift-off assuming 1 second interval acc. to Anderson Eg 6.93

    %WIND EFFECT (ESDU EG 5/1 1972) (Austyn Mair)
    v_w=v_wind*cosd(wind_angle);
    v_m=(v_cr+v_r)/2; %mean velocity of wind
    g_w=(v_m-v_w)/v_m;
    S_g2=S_g2*g_w;
    t_g2=t_g2*sqrt(g_w); 

    %For Airborne Phase
    v_avg=(v_r+v2)/2;
    T=Thrust_avai(v_avg,d,n_pu_to_single);
    D=.5*d*v_avg^2*S*C_d_flap_ground(n_flap_to,n_clmax*C_l_max_flap(n_flap_to),W_to); %C_l_max_flap(n_flap,W,d)
    thita2=asin(T/W_to-D/W_to);
    if thita2<0
        display('Insufficient Thrust');
    end
    S_a=10.5/tan(thita2);
    t_a=S_a/v_avg;

    %WIND EFFECT (ESDU EG 5/1 1972) (Austyn Mair)
    v_w=v_wind*cosd(wind_angle);
    v_m=v_avg; %mean velocity of wind
    g_w=(v_m-v_w)/v_m;
    S_a=S_a*g_w;
    t_a=t_a*sqrt(g_w); 

    %For stop distance and time
    fun=@(v) v./((g./W_to).*((Power_avai(v,d,n_pu_re)./v)+(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))+10*u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))+g*sind(runway_slope));
    S_g3= integral(fun,0,v_cr)+v_cr*2;
    fun=@(v) 1./((g./W_to).*((Power_avai(v,d,n_pu_re)./v)+(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))+10*u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))+g*sind(runway_slope));
    t_g3= integral(fun,0,v_cr)+2;

    %WIND EFFECT (ESDU EG 5/1 1972) (Austyn Mair)
    v_w=v_wind*cosd(wind_angle);
    v_m=v_cr*(.5+.27*(v_w/v_cr)); %mean velocity of wind
    g_w=(v_m-v_w)/v_m;
    S_g3=S_g3*g_w;
    t_g3=t_g3*sqrt(g_w); 

    tod_single=S_g1+S_g2+S_a;
    asd=S_g1+S_g3;
    if abs(tod_single-asd)<=20
        single_balance_field=tod_single;
        break;
    elseif tod_single>asd       
        diff=tod_single-asd;
        single_balance_field = tod_single+(diff/2);
    else
         diff=asd-tod_single;
         single_balance_field = asd+(diff/2);
    end
     
    i=i+1;
end

single_balance_field

if 1.15*distance_both>=single_balance_field
    Balance_Field_Length = 1.15*distance_both
else
    Balance_Field_Length=single_balance_field
end

