%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%   value of idle power and its change due to density is ambigious       %
%   code for rate of descent at a particular altitude not written        %
%   loss of weight due to fuel neglected                                 %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Basic
format long g
clc;
clear;

%% Import data from library
inputs;

%% CURRENT INPUTS
W_kg=16720; % input in kg
W=W_kg*g0; % in newton
v_i=220; % input descent IAS in kts
v=k2m(v_i);  %  IAS in m/s
h0_i=15000; % input in ft
h1_i=1736; % input in ft
h0=f2m(h0_i); %cruise altitude
h1=f2m(h1_i); %final altitude
power_used=0.2; %in term of percentage of full power;
T=0; %input thrust 
dT=0;

%% Calculations

%% Part 1 : General

h=h0:-1:h1;
d=density2(h,dT);
v_t=cas2tas(v,d);
d_avg=mean(d)
v_t_avg=mean(v_t)
mean_square_density=mean(sqrt(1.225./d));

C_lift_g=C_l(W,d0,v); %(g-general)
C_d_g=C_d_flap(0,C_lift_g); % n_flap=0
D=.5.*d0.*v.^2.*S.*C_d_g; 

thita=(D-T)/W;
rate_of_descent=v_t_avg*thita;
time=(h0-h1)/rate_of_descent;
distance=(h0-h1)/thita;

% Part1 Outputs
angle=rad2deg(thita) % in deg
rate=rate_of_descent%197 % in ft/min
time_min=time/60 % in min
distance_Nm=m2Nm(distance) % in Nm
fuel=c*power_used*P_max*time % in kg

%% Part 2 : Maximum Range (BOTH ENGINES FAILURE;Drag due to engine failure not included)
C_lift_r=C_l_tmin;   % r-range
C_d_r=C_d_flap(0,C_lift_r); % n_flap=0
E_r=C_lift_r/C_d_r;
thita_r=1/E_r;
v_r=sqrt(2*W/(d0*S*C_lift_r)) % IAS

h_r=h0:-1:h1;
d_r=density2(h_r,dT);
v_t=cas2tas(v_r,d_r);
d_avg=mean(d_r)
v_t_avg_r=mean(v_t)

rate_of_descent_r=v_t_avg_r*thita_r;
time_r=(h0-h1)/rate_of_descent_r;

% Part 2 Outputs
range_speed=m2k(v_r) %in IAS
rate_of_descent_r=v_t_avg_r*thita_r*197 % in ft/min
angle_r=rad2deg(thita_r) % in deg
range_r=m2Nm(E_r*(h0-h1)) % in Nm
range_time=time_r/60 % in min

%% Part 3 : Minimum rate of descent
C_lift_e=C_l_pmin %e-endurance
C_d_e=C_d_flap(0,C_lift_e); % n_flap=0
E_e=C_lift_e/C_d_e;
thita_e=1/E_e;
v_e=sqrt(2*W/(d0*S*C_lift_e)) % IAS

h_e=h0:-1:h1;
d_e=density2(h_e,dT);
v_t=cas2tas(v_e,d_e);
d_avg=mean(d_e)
v_t_avg_e=mean(v_t)

rate_of_descent_e=v_t_avg_e*thita_e;
time_e=(h0-h1)/rate_of_descent_e;

% Part 3 Outputs
endurance_speed=m2k(v_e)
rate_of_descent_e=v_t_avg_e*thita_e*197
angle_e=rad2deg(thita_e) % in deg
range_e=m2Nm(E_e*(h0-h1)) % in Nm
endurance_time=time_e/60 % in min

%% Necessary graphs
v_test=40:150; %IAS
v_t_avg=v_test*mean_square_density;
C_lift_g=C_l(W,d0,v_test); %(g-general)
C_d_g=C_d_flap(0,C_lift_g); % n_flap=0
D=.5.*d0.*v_test.^2.*S.*C_d_g; 
thita=(D-T)/W;
rate_of_descent=v_t_avg.*thita;
time2=(h0-h1)./rate_of_descent;
distance=(h0-h1)./thita;

%Part1 Outputs
angle=rad2deg(thita);
rate=rate_of_descent*197; % in ft/min
time_min=time2/60; % in min
distance_g=m2Nm(distance); % in Nm

%%
figure (1)
plot(m2k(v_test),angle);
xlabel('IAS (kts)');
ylabel('Angle of Descent (deg)');
title(sprintf('Angle of Descent vs Velocity (IAS) for Descent = %.0f : %.0f ft at \n Weight = %.0f kg',  h0_i, h1_i, W_kg));
grid on

figure(2)
plot(m2k(v_test),rate);
xlabel('IAS (kts)');
ylabel('Rate of Descent (ft/min)');
title(sprintf('Rate of Descent vs Velocity (IAS) for Descent = %.0f : %.0f ft at \n Weight = %.0f kg',  h0_i, h1_i, W_kg));
grid on

figure(3)
plot(m2k(v_test),time_min)
xlabel('IAS (kts)');
ylabel('Time for Descent (min)');
title(sprintf('Time for Descent vs Velocity (IAS) for Descent = %.0f : %.0f ft at \n Weight = %.0f kg',  h0_i, h1_i, W_kg));
grid on

figure(4)
plot(m2k(v_test),distance_g)
xlabel('IAS (kts)');
ylabel('Distance covered (Nm)');
title(sprintf('Distance covered vs Velocity (IAS) for Descent = %.0f : %.0f ft at \n Weight = %.0f kg',  h0_i, h1_i, W_kg));
grid on