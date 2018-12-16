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
glide_slope=3; %degree 
dT=0;

    %%INITIAL VALUE ASSIGNMENT
    time_total_descent=0;
    fuel_total_descent=0;
    distance_total_descent=0;
    h0_loop=h0;
    % loop starts
    while 1

        h1_loop=h0_loop-100;
        if h1_loop<h1
            h1_loop=h1;
        end

        h_descent=h0_loop:-1:h1_loop;
        d_descent=density2(h_descent,dT);
        v_t=v*sqrt(d0./d_descent);
        d_mean=mean(d_descent);
        v_t_avg=mean(v_t);

        C_lift_g=C_l(W,d0,v); %(g-general)
        C_d_g=C_d_flap(0,C_lift_g);
        D_descent=.5.*d0.*v.^2.*S.*C_d_g;

        %glide_slope=(D_descent-Thrust_descent)/W;
        rate_of_descent=v_t_avg*sind(glide_slope);
        time_descent=(h0_loop-h1_loop)/rate_of_descent;
        time_total_descent=time_total_descent+time_descent;


        distance_descent=(h0_loop-h1_loop)/tand(glide_slope);
        distance_total_descent=distance_total_descent+distance_descent;

        %for fuel
%         Power_fuel=0.932825.*P_max.*(d_descent./d0).^0.739667;%Bruening 1992
%         P_mean=mean(Power_fuel);
%         fuel_descent=c*power_used*P_mean*time_descent; %in kg
%         fuel_total_descent=fuel_total_descent+fuel_descent;

          T=D_descent-W*sind(glide_slope);
          P_mean=T*v_t_avg;
          fuel_descent=c*P_mean*time_descent; %in kg
          fuel_total_descent=fuel_total_descent+fuel_descent;
    

        if h1_loop==h1
            break
        end
        h0_loop=h1_loop;
        W=W-fuel_descent*g0;
    end
    fuel_total_descent
    time_total_descent/60
    distance_total_descent/1852