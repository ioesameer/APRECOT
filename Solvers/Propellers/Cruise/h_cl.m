
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%                                                                        %
%       effect of wind not done                                                                 %
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
W0_kg=16000; % input in kg, inital
W0=W0_kg*g0; % in newton
W1_kg=15500; % input in kg, final, W0-minus fuel
W1=W1_kg*g0; % in newton
h_i=10000; % input in ft
h_input=f2m(h_i); % in m
C_l_input=.4;
dT=0;
v_w=0; % in m/s

%% CALCULATION
d1=density2(h_input,dT);
d_input=d1;
W=W0:-10:W1;
C_lift1=C_l_input;
[C_d1,E1]=C_d_flap(0,C_lift1); % n_flap=0 
v1=sqrt(2.*W./(d1*S*C_lift1));

%% Graph for Velocity with varying Weight for Cruise at given Pressure Altitude and C_l
figure(1)
plot(per1000(N2kg(W)),m2k(v1));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Weight (1000kg)');
ylabel('TAS (kts)');
title(sprintf('Increasing Velocity (TAS) with Weight Reduction for Cruise at \n Pressure Altitude = %.0f ft & C_{lift} = %.2f for Fuel = %.0f kg', h_i, C_l_input, W0_kg-W1_kg));


%% For Range and Endurance of Cruise at Given C_l and Pressure Altitude

R2=0;
Endu2=0;
i=0;
for W=W0:-10:W1
    i=i+1;
    d2=d1;
    C_lift2=C_l_input;
    [C_d2,E2]=C_d_flap(0,C_lift2); % n_flap=0  
    v2=sqrt(2.*W./(d2*S*C_lift2));
    R2=R2+n_pr_design.*(v2-v_w)/v2/c_n*E2*log(W/(W-10));
    SR2=n_pr_design.*(v2-v_w)/v2/c_n*E2*log(W/(W-10));
    Endu2=Endu2+n_pr_design./c_n.*sqrt(2*d_input*S).*(C_lift2.^1.5)./C_d2.*((W-10).^(-.5)-(W).^(-.5));

    W2_temp(i)=W;
    SR2_temp(i)=SR2;
end

Range_point=m2Nm(max(R2)) % Nm
Endurance_point=max(Endu2)/60 % in min



%% Graph for varying Pressure Altitude at given C_l
i=0;
h3=0;
h3_step=50;

while h3<9000
    
    i=i+1;
    h3=h3+h3_step;
    R3=0;
    Endu3=0;
    for W=W0:-10:W1
        
        d3=density2(h3,dT);
        C_lift3=C_l_input;
        [C_d3,E3]=C_d_flap(0,C_lift3); % n_flap=0
        v3=sqrt(2.*W./(d3*S*C_lift3));
        R3=R3+n_pr_design.*(v3-v_w)./v3/c_n*E3*log(W/(W-10));
        Endu3=Endu3+n_pr_design./c_n.*sqrt(2*d3*S).*(C_lift3.^1.5)./C_d3.*((W-10).^(-.5)-(W).^(-.5));
        
    end

    range3(i)=max(R3);
    endurance3(i)=max(Endu3);
    h3_temp(i)=h3;

    end

% Range vs Pressure Altitude
figure(2)
plot(per1000(m2f(h3_temp)),m2Nm(range3));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Range (Nm)');
title(sprintf('Range vs Pressure Altitude for given C_{lift} = %.2f for Fuel = %.0f kg', C_l_input, W0_kg-W1_kg));

% Endurance vs Pressure Altitude
figure(3)
plot(per1000(m2f(h3_temp)),endurance3/60);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Endurance (min)');
title(sprintf ('Endurance vs Pressure Altitude for C_{lift} = %.2f for Fuel = %.0f kg', C_l_input, W0_kg-W1_kg));


%% Graph for varying C_l at given Pressure Altitude
i=1;
C_l4=.1;
C_l4_step=.2;

while C_l4<4

    C_l4=C_l4+C_l4_step;
    R4=0;
    Endu4=0;
    h4=h_input;
    d4=density2(h4,dT);
    for W=W0:-10:W1
        
        C_lift4=C_l4;
        [C_d4,E4]=C_d_flap(0,C_lift4); % n_flap=0
        v4=sqrt(2.*W./(d4*S*C_lift4));
        R4=R4+n_pr_design*(v4-v_w)/v4/c_n*E4*log(W/(W-10));
        Endu4=Endu4+n_pr_design./c_n.*sqrt(2*d4*S).*(C_lift4.^1.5)./C_d4.*((W-10).^(-.5)-(W).^(-.5));
        
    end
    
    range4(i)=max(R4);
    endurance4(i)=max(Endu4);
    C_l4_temp(i)=C_l4;
    i=i+1;

end

% Range vs C_l
figure(4)
plot(C_l4_temp,m2Nm(range4));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('C_{lift}');
ylabel('Range (Nm)');
title(sprintf('Range vs C_{lift} for Pressure Altitude = %.0f ft for Fuel = %.0f kg', h_i, W0_kg-W1_kg));

% Endurance vs C_l
figure(5)
plot(C_l4_temp,endurance4/60);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('C_{lift}');
ylabel('Endurance (min)');
title(sprintf('Endurance vs C_{lift} for Pressure Altitude = %.0f ft for Fuel = %.0f kg', h_i, W0_kg-W1_kg));


