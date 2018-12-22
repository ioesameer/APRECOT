%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%                                                                        %
%         Specific range                                                 %
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
W1_kg=15500; % input in kg, final, W0-minus fuel
W1=W1_kg*g0; % in newton
v_i=214; % input TAS in kts
v_input=k2m(v_i); % TAS in m/s
h_i=20000; % input in ft
h_input=f2m(h_i); % in m
dT=0;
v_w=0; %headwind positive

%% CALCULATION(1)
d1=density2(h_input,dT);
d_input=d1;
W=W0:-10:W1;
C_lift1=2*W/(d1*v_input^2*S);
[C_d1,E1]=C_d_flap(0,C_lift1); % n_flap=0 

%% Graph for C_l with varying Weight for Cruise at given Pressure Altitude and Velocity (TAS)
figure(1)
plot(per1000(N2kg(W)),C_lift1);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Weight (1000kg)');
ylabel('C_{lift}');
title(sprintf('Change in C_{lift} with Weight Reduction at \n Pressure Altitude = %.0f ft & Velocity (TAS) = %.2f kts for Fuel = %.0f kg', h_i, m2k(v_input), W0_kg-W1_kg));

%% Graph for Lift to Drag Ratio (E) with varying Weight for Cruise at given Pressure Altitude and Velocity (TAS)
figure(2)
plot(per1000(N2kg(W)),E1);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Weight (1000kg)');
ylabel('Lift to Drag Ratio (E)');
title(sprintf('Change in Lift to Drag Ratio (E) with Weight Reduction at \n Pressure Altitude = %.0f ft & Velocity (TAS) = %.2f kts for Fuel = %.0f kg', h_i, m2k(v_input), W0_kg-W1_kg));


%% For Range and Endurance of Cruise at given Pressure Altitude and Velocity (TAS)
R2=0;
Endu2=0;
i=0;
for W=W0:-10:W1
    i=i+1;
    C_lift2=2*W/(d_input*v_input^2*S);
    [C_d2,E2]=C_d_flap(0,C_lift2); % n_flap=0 
    R2=R2+n_pr_design.*(v_input-v_w)./v_input./c_n*E2*log(W/(W-10));
    SR2=n_pr_design.*(v_input-v_w)./v_input./c_n*E2*log(W/(W-10))*g0/10;
    Endu2=Endu2+n_pr_design./c_n.*sqrt(2*d_input*S).*(C_lift2.^1.5)./C_d2.*((W-10).^(-.5)-(W).^(-.5));
    W2_temp(i)=W;
    SR2_temp(i)=SR2; 
end

Range_point=m2Nm(max(R2))
Endurance_point=max(Endu2)
Specific_Range=m2Nm(max(SR2))

% Graph for Specific Range with varying Weight at given Pressure Altitude and Velocity (TAS)
figure(3)
plot(per1000(N2kg(W2_temp)),m2Nm(SR2_temp));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Weight (1000kg)');
ylabel('Specific Range (Nm/kg)');
title(sprintf('Specific Range vs Weight at \n Pressure Altitude = %.0f ft Velocity (TAS) = %.2f kts for Fuel = %.0f kg', h_i, m2k(v_input), W0_kg-W1_kg));

%% Graph for varying Velocity (TAS) at given C_l
i=0;
v3=30;
v3_step=5;

while v3<150

    i=i+1;
    v3=v3+v3_step;
    R3=0;
    Endu3=0;
    for W=W0:-10:W1
        
        C_lift3=2.*W./(d_input.*v3.^2.*S);
        [C_d3,E3]=C_d_flap(0,C_lift3); % n_flap=0 
        R3=R3+n_pr_design.*(v3-v_w)./v3./c_n*E3*log(W/(W-10));
        SR3=n_pr_design.*(v3-v_w)./v3./c_n*E3*log(W0/(W0-10));
        Endu3=Endu3+n_pr_design./c_n.*sqrt(2*d_input*S).*(C_lift3.^1.5)./C_d3.*((W-10).^(-.5)-(W).^(-.5));
        
    end
    
    range3(i)=max(R3);
    endurance3(i)=max(Endu3);
    v3_temp(i)=v3;
    SR3_temp(i)=SR3;
    
end

% For long range (added lately)
SR3_temp_max=max(SR3_temp) % in meters
long_range_posn=max(find(abs(SR3_temp-.99*SR3_temp_max)<1));
long_range=SR3_temp(long_range_posn);
long_range_velocity=v3_temp(long_range_posn);
SR3_temp_max=m2Nm(max(SR3_temp))

% Range vs Velocity (TAS)
figure(4)
plot(m2k(v3_temp),m2Nm(range3));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('TAS (kts)');
ylabel('Range (Nm)');
title(sprintf('Range vs Velocity (TAS) at Pressure Altitude = %.0f ft for Fuel = %.0f kg', h_i, W0_kg-W1_kg));

% Endurance vs Velocity (TAS)
figure(5)
plot(m2k(v3_temp),endurance3/60);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('TAS (kts)');
ylabel('Endurance (min)');
title(sprintf('Endurance vs Velocity (TAS) at Pressure Altitude = %.0f ft for Fuel = %.0f kg', h_i, W0_kg-W1_kg));

figure(6)
plot(m2k(v3_temp),m2Nm(SR3_temp));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('TAS (kts)');
ylabel('Specific Range (Nm/kg)');
title(sprintf('Specific Range vs Velocity (TAS) for Pressure Altitude = %.0f ft for Fuel = %.0f kg', h_i, W0_kg-W1_kg));


%% Graph for varying Pressure Altitude at given Velocity (TAS)

i=0;
h4=0;
h4_step=500;

while h4<9000

    i=i+1;
    h4=h4+h4_step;
    R4=0;
    Endu4=0;
    d4=density2(h4,dT);
    for W=W0:-10:W1
        
        C_lift4=2.*W./(d4.*v_input.^2.*S);
        C_d4=C_d_flap(0,C_lift4);% n_flap=0 
        E4=C_lift4./C_d4;
        R4=R4+n_pr_design.*(v_input-v_w)./v_input./c_n*E4*log(W/(W-10));
        Endu4=Endu4+n_pr_design./c_n.*sqrt(2*d4*S).*(C_lift4.^1.5)./C_d4.*((W-10).^(-.5)-(W).^(-.5));
        
    end
    
    range4(i)=max(R4);
    endurance4(i)=max(Endu4);
    h4_temp(i)=h4;

end

% Range vs Pressure Altitude
figure(7)
plot(per1000(m2f(h4_temp)),m2Nm(range4));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Range (Nm)');
title(sprintf('Range vs Pressure Altitude at Velocity (TAS) = %.2f kts for Fuel = %.0f kg', m2k(v_input), W0_kg-W1_kg));

% Endurance vs Pressure Altitude
figure(8)
plot(per1000(m2f(h4_temp)),endurance4/60);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Endurance (min)');
title(sprintf('Endurance vs Pressure Altitude at Velocity (TAS) = %.2f kts for Fuel = %.0f kg', m2k(v_input), W0_kg-W1_kg));


