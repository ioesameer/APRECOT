
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%                                                                        %
%       effect of temperature not done                                                                 %
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
W0_kg=16000; % input in kg, initial
W0=W0_kg*g0; % in newton
W1_kg=15500; % inout in kg, final, W0-minus fuel
W1=W1_kg*g0; % in newton
v_i=214; % input TAS in kts
v_input=k2m(v_i); % TAS in m/s
C_l_input=.8;
dT=0;
v_w=0;

%% CALCULATION(1)
W=W0:-10:W1;
d1=2.*W./(v_input^2*S*C_l_input);
[~,T1]=altitude(d1);
d1=d1.*T1./(T1+dT);
h1=altitude(d1); % in meter

%% Graph for Pressure Altitude with varying Weight for Cruise at given Velocity (TAS) and C_l
figure(1)
plot(per1000(N2kg(W)),per1000(m2f(h1)));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Weight (1000kg)');
ylabel('Pressure Altitude (1000ft)');
title(sprintf('Increasing Pressure Altitude with Weight Reduction at \n Velocity (TAS) = %.2f kts and C_{lift} = %.2f for Fuel = %.0f kg', m2k(v_input), C_l_input, W0_kg-W1_kg));


%% For Range and Endurance of Cruise at given C_l and Velocity

R2=0;
Endu2=0;
i=0;
for W=W0:-10:W1
    i=i+1;
    d2=d1;
    [C_d2,E2]=C_d_flap(0,C_l_input); % n_flap=0    
    R2=R2+n_pr_design*(v_input-v_w)/v_input/c_n*E2*log(W/(W-10));
    Endu2=Endu2+n_pr_design./c_n.*sqrt(2*d2*S).*(C_l_input.^1.5)./C_d2.*((W-10).^(-.5)-(W).^(-.5));
    W2_temp(i)=W;
end
Range_point=m2Nm(max(R2)) % in Nm
Endurance_point=max(Endu2)/60 % in min




%% Graph for varying Velocity (TAS) at given C_l
i=0;
v3=30;
v3_step=1;

while v3<150

    i=i+1;
    v3=v3+v3_step;
    R3=0;
    Endu3=0;
    for W=W0:-10:W1

        [C_d3,E3]=C_d_flap(0,C_l_input); % n_flap=0 
        d3=2*W/(v3^2*S*C_l_input);
        [~,T3]=altitude(d3);
        d3=d3.*T3./(T3+dT);
        R3=R3+n_pr_design*(v3-v_w)/v3/c_n*E3*log(W/(W-10));
        SR3=n_pr_design*(v3-v_w)/v3/c_n*E3*log(W0/(W0-10));
        Endu3=Endu3+n_pr_design./c_n.*sqrt(2*d3*S).*(C_l_input.^1.5)./C_d3.*((W-10).^(-.5)-(W).^(-.5));

    end

    range3(i)=max(R3);
    endurance3(i)=max(Endu3);
    v3_temp(i)=v3;
    SR3_temp(i)=SR3;

end

% Range vs Velocity (TAS)
figure(2)
plot(m2k(v3_temp),m2Nm(range3));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('TAS (kts');
ylabel('Range (Nm)');
title(sprintf('Range vs Velocity (TAS) at C_{lift} = %.2f for Fuel = %.0f kg', C_l_input, W0_kg-W1_kg));

% Endurance vs Velocity (TAS)
figure(3)
plot(m2k(v3_temp),endurance3/60);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('TAS (kts)');
ylabel('Endurance (min');
title(sprintf('Endurance vs Velocity (TAS) at C_{lift} = %.2f for Fuel = %.0f kg', C_l_input, W0_kg-W1_kg));

% Specific Range vs Velocity (TAS)
figure(4)
plot(m2k(v3_temp),m2Nm(SR3_temp));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('TAS (kts)');
ylabel('Specific Range (Nm/kg)');
title(sprintf('Specific Range vs Velocity (TAS) at C_{lift} = %.2f for Fuel = %.0f kg', C_l_input, W0_kg-W1_kg));


%% Graph for varying Cl at given Velocity (TAS)
i=0;
C_l4=0;
C_l4_step=.05;

while C_l4<4

    i=i+1;
    C_l4=C_l4+C_l4_step;
    R4=0;
    Endu4=0;
    for W=W0:-10:W1
        
        C_lift4=C_l4;
        [C_d4,E4]=C_d_flap(0,C_lift4); % n_flap=0 
        d4=2*W/(v_input^2*S*C_l_input);
        [~,T4]=altitude(d4);
        d4=d4.*T4./(T4+dT);

        R4=R4+n_pr_design*(v3-v_w)/v3/c_n*E4*log(W/(W-10));
        Endu4=Endu4+n_pr_design./c_n.*sqrt(2*d4*S).*(C_lift4.^1.5)./C_d4.*((W-10).^(-.5)-(W).^(-.5));
        
    end

    range4(i)=max(R4);
    endurance4(i)=max(Endu4);
    C_l4_temp(i)=C_l4;


end

% Range vs C_l
figure(5)
plot(C_l4_temp,m2Nm(range4));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('C_{lift}');
ylabel('Range (Nm)');
title(sprintf('Range vs C_{lift} at Velocity (TAS)= %.2f kts for Fuel = %.0f kg', v_input, W0_kg-W1_kg));

% Endurance vs C_l
figure(6)
plot(C_l4_temp,endurance4/60)
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('C_{lift}');
ylabel('Endurance (min)');
title(sprintf('Endurance vs C_{lift} at Velocity (TAS) = %.2f kts for Fuel = %.0f kg', v_input, W0_kg-W1_kg));




