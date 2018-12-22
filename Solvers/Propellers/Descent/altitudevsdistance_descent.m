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
W=W_kg*g; % in newton
h0_i=1500; % input in ft, initial
h_initial=f2m(h0_i); %in meter
h1_i=17000; % input in ft, final
h_final=f2m(h1_i); % in meter
v_d_i=220; % input IAS in kts
v_descent=k2m(v_d_i);  % IAS in m/s
dT=0; %ISA+ temperature
n_load=1; %load factor climb
n_flap=0;%flap position climb
power_used=0.2; %in term of percentage of full power;
Thrust_descent=0; %input thrust 


%% FOR OPTIMUM ALTITUDE
i=1;  
%%                                                              CALCULATION FOR CLIMB

%%INITIAL VALUE ASSIGNMENT
time_total_descent=0;
fuel_total_descent=0;
distance_total_descent=0;
% loop starts
while 1

    h_initial_loop=h_final-f2m(100);
    if h_initial_loop<h_initial
        h_initial_loop=h_initial;
    end

    h_descent=h_final:-1:h_initial_loop;
    d_descent=density2(h_descent,dT);
    v_t=v_descent*sqrt(d0./d_descent);
    d_mean=mean(d_descent);
    v_t_avg=mean(v_t);

    C_lift_g=C_l(W,d0,v_descent); %(g-general)
    C_d_g=C_d_flap(0,C_lift_g);
    D_descent=.5.*d0.*v_descent.^2.*S.*C_d_g; 

    thita=(D_descent-Thrust_descent)/W;
    rate_of_descent=v_t_avg*thita;
    time_descent=(h_final-h_initial_loop)/rate_of_descent;
    time_total_descent=time_total_descent+time_descent;
    t(i)=time_total_descent;
    distance_descent=(h_final-h_initial_loop)/tan(thita);
    distance_total_descent=distance_total_descent+distance_descent;
    d(i)=distance_total_descent;
    %for fuel
    Power_fuel=0.932825.*P_max.*(d_descent./d0).^0.739667;%Bruening 1992
    P_mean=mean(Power_fuel);
    fuel_descent=c*power_used*P_mean*time_descent; %in kg
    fuel_total_descent=fuel_total_descent+fuel_descent;
    f(i)=fuel_total_descent;
   
    h_final=h_initial_loop;
    W=W-fuel_descent*g0;
    h(i)=h_final;
    i=i+1;
     if h_initial_loop==h_initial
        break
    end
end

figure(1)
plot(m2Nm(d),per1000(m2f(h)));
figure(2)
plot(t/60,per1000(m2f(h)));
figure(3)
plot(f,per1000(m2f(h)));





