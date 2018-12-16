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
h_step=-f2m(100);
v_cl_i=160; % input IAS in kts
v_climb=k2m(v_cl_i); % IAS in m/s
%v_cr_i=190; % input IAS kts
v_cr_i=200; % input TAS kts
v_cruise=k2m(v_cr_i); % IAS in m/s
n_pu_cr=.9; %acceleration phase
n_pu=1; %in terms of full power climb
dT=0; %ISA+ temperature
n_load=1; %load factor climb
n_flap=0;%flap position climb
destination_i=127.4; % input in Nm
destination=Nm2m(destination_i); % in meter

%% FOR OPTIMUM ALTITUDE
h_final3=h_final:h_step:h_initial;
i=1;
for h_final2=h_final:h_step:h_initial    
    %%                                                              CALCULATION FOR CLIMB
    %% INITIAL VALUE ASSIGNMENT
    time_total_climb=0;
    fuel_total_climb=0;
    distance_total_climb=0;
    h_initial_loop=h_initial;
    while 1

        h_final_loop=h_initial_loop+100;
        if h_final_loop>h_final2
            h_final_loop=h_final2;
        end

        %Time
        fun=@(h) 1./(SEP(v_climb.*sqrt(d0./density2(h,dT)),density2(h,dT),n_pu,W,n_flap));
        time_climb=integral(fun,h_initial_loop,h_final_loop); %unit seconds
        time_total_climb=time_total_climb+time_climb;

        %Fuel
        h_fuel=h_initial_loop:h_final_loop;
        d_fuel=density2(h_fuel,dT);
        d_fuel_mean=mean(d_fuel);
        Power_fuel=0.932825.*P_max.*(d_fuel./d0).^0.739667;%Bruening 1992

        P_mean=mean(Power_fuel);
        fuel_climb=c*n_pu*P_mean*time_climb; %in kg
        fuel_total_climb=fuel_total_climb+fuel_climb;

        %Distance
        h_angle=h_initial_loop:h_final_loop;
        d_dist=density2(h_angle,dT);
        d_dist_mean=mean(d_dist);
        v_t=v_climb.*sqrt(d0./d_dist);
        v_t_avg=mean(v_t); 
        thita_angle=rate_of_climb(d_dist_mean,v_t_avg,W,n_pu,n_flap); %velocity is true
        thita=mean(thita_angle);
        distance_climb=v_t_avg*cos(thita)*time_climb; %in metre
        distance_total_climb=distance_total_climb+distance_climb;

        if h_final_loop==h_final2
            break;
        end
        h_initial_loop=h_final_loop;
        W=W-fuel_climb*g0;

    end

    W_afterclimb=W;
    distance_total_climb_Nm=m2Nm(distance_total_climb);
    fuel_total_climb;
    time_climb_min=time_total_climb/60;
    %%                                                CALCULATION FOR DESCENT
    %% CURRENT INPUTS
    W=W_afterclimb;
    v_d_i=220; % input IAS in kts
    v_descent=k2m(v_d_i);  % IAS in m/s
    power_used=0.2; %in term of percentage of full power;
    Thrust_descent=0; %input thrust 

    %%INITIAL VALUE ASSIGNMENT
    time_total_descent=0;
    fuel_total_descent=0;
    distance_total_descent=0;
    h_final_loop2=h_final2;
    % loop starts
    while 1

        h_initial_loop2=h_final_loop2-100;
        if h_initial_loop2<h_initial
            h_initial_loop2=h_initial;
        end

        h_descent=h_final_loop2:-1:h_initial_loop2;
        d_descent=density2(h_descent,dT);
        v_t=v_descent*sqrt(d0./d_descent);
        d_mean=mean(d_descent);
        v_t_avg=mean(v_t);

        C_lift_g=C_l(W,d0,v_descent); %(g-general)
        C_d_g=C_d_flap(0,C_lift_g);
        D_descent=.5.*d0.*v_descent.^2.*S.*C_d_g; 

        thita=(D_descent-Thrust_descent)/W;
        rate_of_descent=v_t_avg*thita;
        time_descent=(h_final_loop2-h_initial_loop2)/rate_of_descent;
        time_total_descent=time_total_descent+time_descent;


        distance_descent=(h_final_loop2-h_initial_loop2)/tan(thita);
        distance_total_descent=distance_total_descent+distance_descent;

        %for fuel
        Power_fuel=0.932825.*P_max.*(d_descent./d0).^0.739667;%Bruening 1992
        P_mean=mean(Power_fuel);
        fuel_descent=c*power_used*P_mean*time_descent; %in kg
        fuel_total_descent=fuel_total_descent+fuel_descent;

        if h_initial_loop2==h_initial
            break
        end
        h_final_loop2=h_initial_loop2;
        W=W-fuel_descent*g0;

    end
    W_afterdescent=W;
    time_descent_min=time_total_descent/60;
    distance_total_climb_Nm=m2Nm(distance_total_descent);
    fuel_total_descent;


    %% FOR ACCELERATION PHASE
    d_h_final=density2(h_final2,dT);
    v_t_climb=cas2tas(v_climb,d_h_final);
    %v_t_cruise=cas2tas(v_cruise,d_h_final); 
    v_t_cruise=v_cruise;
    fun= @(v) v./(1/N2kg(W_afterclimb).*(Thrust_avai(v,d_h_final,n_pu_cr)-.5.*d_h_final.*v.^2.*S.*C_d_flap(0,C_l(W_afterclimb,d_h_final,v))));
    distance_acc=integral(fun,v_t_climb,v_t_cruise);
    fun= @(v) 1./(1/N2kg(W_afterclimb).*(Thrust_avai(v,d_h_final,n_pu_cr)-.5.*d_h_final.*v.^2.*S.*C_d_flap(0,C_l(W_afterclimb,d_h_final,v))));
    time_acc(i)=integral(fun,v_t_climb,v_t_cruise);
    power_acc=0.932825.*P_max.*(d_h_final./d0).^0.739667;%Bruening 1992;
    fuel_acc=n_pu_cr*power_acc*time_acc(i)*c;
    W_afteracc=W_afterclimb-fuel_acc;
    if time_acc(i)<0;
        display('Error');
        fuel_acc=0;
        time_acc(i)=0;
    end
    
    distance2cruise(i)=destination-(distance_total_climb+distance_total_descent+distance_acc);

    %% CRUISE
    time_cruise=distance2cruise(i)/v_t_cruise;
    power_cruise=Power_req(v_t_cruise,density2(h_final2,dT),W_afterclimb,0); %Power_req(v,d,W,n_flap) %n=flap position
    fuel_cruise=power_cruise*time_cruise*c;
    W_aftercruise=W_afteracc-fuel_cruise;

    %% CRUISE CHECKING
    if distance2cruise(i)<0
        display('Cruise not possible');
        fuel_cruise=0;
        time_cruise=0;
    end

    total_fuel(i)=fuel_cruise+fuel_acc+fuel_total_climb+fuel_total_descent;
    total_time(i)=time_cruise+time_acc(i)+time_total_climb+time_total_descent;
    i=i+1;

end

%% Optimum values
if distance2cruise<0
    display('Cruise not possible');
elseif time_acc<0
    display('Error');
else
    [optimum_total_fuel, p] = min(total_fuel);
    optimum_altitude=m2f(h_final3(p))
    optimum_total_fuel
    optimum_total_time = total_time(p)/60
end

%% Graphs for Fuel Consumed and Total Time
figure(1)
plot(per1000(m2f(h_final3)),total_fuel);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Fuel comsumed (kg)');
title(sprintf('Fuel Consumed vs Pressure Altitude for Weight = %.0f kg',  W_kg));

figure(2)
plot(per1000(m2f(h_final3)),total_time);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Flight Time (min)');
title(sprintf('Flight Time for Climb, Cruise & Descent vs Pressure Altitude \n for Weight = %.0f kg',  W_kg));