%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%                                                                        %
%                                                                        %
%                                                                        %
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
W0_kg=16000; % input in kg, intial
W0=W0_kg*g0; % in newton
W1_kg=15600; % input in kg final, final, W0-minus fuel
W1=W1_kg*g0; % in newton
dT=0;
v_w=0; % input in m/s
n_pr=n_pr_design;

%% CALCULATION
C_l_input=C_l_pmin;
i=0;
h3=0;
h3_step=200;

while h3<9000
    if W1<2
        W1=2;
    end
    i=i+1;
    h3=h3+h3_step;
    R3=0;
    Endu3=0;
    for W=W0:-10:W1
        d3=density2(h3,dT);
        C_lift3=C_l_input;
        [C_d3,E3]=C_d_flap(0,C_lift3);        
        v3=sqrt(2.*W./(d3*S*C_lift3));
        Endu3=Endu3+n_pr./c_n.*sqrt(2*d3*S).*(C_lift3.^1.5)./C_d3.*((W-10).^(-.5)-(W).^(-.5));
        R3=R3+(n_pr/c_n*E3*log(W/(W-10)));
    end
    range3(i)=max(R3);
    endurance3(i)=max(Endu3);
    h3_temp(i)=h3;
    v3_temp(i)=v3;
end

%% Graphs
figure(1)
plot(per1000(m2f(h3_temp)),endurance3/60);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Endurance (min)');
title(sprintf('Best Endurance vs Pressure Altitude for Fuel = %.0f kg', W0_kg-W1_kg));

figure(2)
plot(per1000(m2f(h3_temp)),m2k(v3_temp));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('TAS (kts)');
title(sprintf('Velocity (TAS) vs Pressure Altitude for Fuel = %.0f kg', W0_kg-W1_kg));

figure(3)
plot(per1000(m2f(h3_temp)),m2Nm(range3));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Range (Nm)');
title(sprintf('Range vs Pressure Altitude for Best Endurance & Fuel = %.0f kg', W0_kg-W1_kg));
