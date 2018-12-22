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
constants;

%% CURRENT INPUTS
W0_kg=18000; % input in kg, inital
W1_kg=17600; % input in kg, final, W0-minus fuel
W0=W0_kg*g0; % in newton
W1=W1_kg*g0; % in newton
h_i=5000; % input in ft
h=f2m(5000); % in metre;
h0_i=0; % input in ft, lower limit
h1_i=15000; % input in ft, higher limit
h_step=100; % input in ft, step size
h_range=f2m(h0_i:h_step:h1_i);
dT=0; %ISA+ temperature
d = density2(h,dT);
n_flap=0; % input flap position, deg
n_pr=n_pr_design;

v_step=0.1;
v=0:v_step:130;
v_w=20; %HW is +ve and TW is -

if v_w>=0
    j=find(v==v_w);
else
    j=1;
end

%% Create Plot for Power Required
P_req = Power_req(v,d,W0,n_flap);

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
xlim(axes1,[m2k(v_w) m2k(max(v))]);
ylim(axes1,[0 2000]);
box(axes1,'on');
hold(axes1,'all');

plot(m2k(v),per1000(P_req)); %Velocity in Knots, Power in kW

%% Best range velocity, range, E at true air speed
[a,b]=size(v);
m_prev=10e20; %tends to inf
for i=1:b
    x=isnan(P_req(i));
    if v(i)~=0 && x~=1
        m=P_req(i)/v(i);
    else
        m=10e19; %tends to inf
    end
    if m_prev>m
        m_prev=m;
    else
        break;
    end
end

Best_range_velocity_no_wind=v(i-1)
C_l_1=C_l(W0,d,v(i-1));
[C_d_1, E1]=C_d_flap(n_flap,C_l_1);
Best_Range_no_wind=m2Nm(n_pr/c_n*E1*log(W0/W1))
E_no_wind=E1

% Create Plot of line tangent to Power required passing through origin
v2=0:v_step:v(i);
y=m.*v2;
plot(m2k(v2),per1000(y));

%% Create Plot for best range velocity w.r.t ground
m_prev=10e20; %tends to inf

for i=j:b
    x=isnan(P_req(i));
    if (v(i)-v_w)~=0 && x~=1
        m=P_req(i)/(v(i)-v_w);
    else
        m=10e19; %tends to inf
    end
    if m_prev>m
        m_prev=m;
    else
        break;
    end
end

Best_range_velocity_with_wind=v(i-1)
C_l_2=C_l(W0,d,v(i-1));
[C_d_2,E3]=C_d_flap(n_flap,C_l_2);
Best_Range_with_wind=m2Nm(n_pr/c_n*(v(i-1)-v_w)/v(i-1)*E3*log(W0/W1))
E_with_wind=E3

% Create Plot of line tangent to Power required passing through wind velocity
v3=v_w:v_step:v(i);
z=m.*(v3-v_w);
plot(m2k(v3),per1000(z));

%% Labeling Figure 1
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('TAS (kts)');
ylabel('Power (KW)');
title(sprintf('Deviation of Max Range Velocity with V_{wind} = %.2f m/s', v_w));
legend('Power Required', 'Velocity without wind', 'Velocity with wind');

%% Best Range Velocity w or w/o wind vs Pressure Altitude
d_range=density2(h_range,dT);
z=numel(h_range);
vel_d=zeros(1,z);
Best_Range_wind=zeros(1,z);
E=zeros(1,z);

for i=1:z
    P_req = Power_req(v,d_range(i),W0,n_flap);
    m_prev=10e20; %tends to inf
    for f=j:b
        x=isnan(P_req(f));
        if (v(f)-v_w)~=0 && x~=1
            m=P_req(f)/(v(f)-v_w);
        else
            m=10e19; %tends to inf
        end
        if m_prev>m
            m_prev=m;
        else
            break;
        end
    end    
    vel_d(i)=v(f-1);
    C_l_3=C_l(W0,d,vel_d(i));
    [C_d_3,E3]=C_d_flap(n_flap,C_l_3);
    E(i)=E3;
    Best_Range_wind(i)=m2Nm(n_pr/c_n*(vel_d(i)-v_w)/vel_d(i)*E3*log(W0/W1));
end

%% Best Range with varying Pressure Altitude
figure(2)
plot(per1000(m2f(h_range)),Best_Range_wind);

grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Range (Nm)');
title(sprintf('Best Range with varying Pressure Altitude with \n V_{wind} = %.2f m/s for Fuel = %.0f kg', v_w, W0_kg-W1_kg));

%% Velocity (TAS) vs Pressure Altitude for Best Range
figure(3)
plot(per1000(m2f(h_range)),m2k(vel_d));

grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('TAS (kts)');
title(sprintf('Velocity (TAS) vs Pressure Altitude for Best Range & \n V_{wind} = %.2f m/s for Fuel = %.0f kg', v_w, W0_kg-W1_kg));

%% Lift to Drag Ratio vs Pressure Altitude for Best Range
figure(4)
plot(per1000(m2f(h_range)),E);

grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
xlabel('Pressure Altitude (1000ft)');
ylabel('Lift to Drag Ratio');
title(sprintf('Lift to Drag Ratio (E) vs Pressure Altitude for Best Range & \n V_{wind} = %.2f m/s for Fuel = %.0f kg', v_w, W0_kg-W1_kg));