%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
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
airport;
coef_fric;

%% Current Inputs
Temp=15;%ambient air temp
n_pu_to=.9; %in terms of power by both engines
n_pu_to1=.5; %n_pu_to1 in dropdown menu
n_pu_seg2=.5; %maximum continuous/take off in option
n_pu_seg4=.5; %maximum continuous/take off in option
n_flap_to=15; %input flap postion takeoff, deg
n_pu_re=0; %in decimal terms compared to full power
v_wind=0; % in m/s
wind_angle=0;%in degree
asd_given=800; % in meters
tod_given=800; % in meters
n_clmax=.8; %fraction of maximum coefficient of lift used for the configuration
phi2=0; %second segment bank angle unit degree
phi4=0; %fourth segment bank angle unit degree
n_w=100; %no. of weight iterations
n_r=20; %no. of rotation ratio iterations
n_2=2; %no. of v2 ratio iterations, not more than 4

%% DENSITY CALCULATION
[d1,Temp1]=density(h_elev);
Temp=Temp+273.16;
d=d1*Temp1/Temp;
%% Rotation velocity assignment
k=1;

for v2_ratio=linspace(1.13,1.4,n_2)
    %% Pre-Outer Loop Calculation
    i=1;
    W_asd=zeros(1,n_r);
    W_tod=zeros(1,n_r);
    W_angle2=zeros(1,n_r);
    v_ratio=linspace(0.84,1,n_r);
    %% Outer Loop
    for v_ratio_loop=linspace(0.84,1,n_r)
        %% Pre-inner Loop Calculation
        j=1;
        asd=zeros(1,n_w);
        tod=zeros(1,n_w);
        angle2=zeros(1,n_w);
        W=zeros(1,n_w);

        %% Inner Loop
        for W_to=linspace(W_empty,W_mtow,n_w)
            v_r=1.1*v_stall(n_flap_to,d,W_to,1);
            v_cr=v_ratio_loop*v_r;
            v2=v2_ratio*v_stall(n_flap_to,d,W_to,1);
            
            %For Ground Run till Critical Velocity
            fun=@(v) v./((g./W_to).*((Power_avai(v,d,n_pu_to)./v)-(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))-u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))-g*sind(runway_slope));
            S_g1= integral(fun,.010,v_cr);

            %For Ground Run from Critical Velocity to Rotation Velocity to Lift-Off
            fun=@(v) v./((g./W_to).*((Power_avai(v,d,n_pu_to1)./v)-(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))-u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))-g*sind(runway_slope));
            S_g2=integral(fun,v_cr,v_r); % till Rotation
            S_g2=S_g2+(v_cr*1); % till Lift-off assuming 1 second interval acc. to Anderson Eg 6.93

            %From Lift-Off to Screen Height
            v_avg=(v_r+v2)/2;
            T=Thrust_avai(v_avg,d,n_pu_to1);
            D=.5*d*v_avg^2*S*C_d_flap_ground(n_flap_to,n_clmax*C_l_max_flap(n_flap_to),W_to); %C_l_max_flap(n_flap,W,d)
            thita2=asin(T/W_to-D/W_to);
            S_a=10.5/tan(thita2);

            %For Critical Velocity to Complete Stop
            fun=@(v) v./((g./W_to).*((Power_avai(v,d,n_pu_re)./v)+(.5.*d.*v.^2.*S.*C_d_flap_ground(n_flap_to,C_l_ground,W_to))+10*u_r.*(W_to-(.5.*d.*v.^2.*S.*C_l_ground)))+g*sind(runway_slope));
            S_g3= integral(fun,0,v_cr)+v_cr*2;

            %For second segment obstacle
            %Second Segment
            n_load2=cosd(phi2);
            d_second=density(h_elev+h_third/2); %effect of temperature not added
            W_second=W_to;
            C_l_second=C_l(W_second,d_second,v2);
            C_d_second=C_d_flap(n_flap_to,C_l_second);
            T_second=Thrust_avai(v2,d_second,n_pu_seg2);         
            D_second=.5*d_second*(v2)^2*S*C_d_second;
            angle_second=T_second/(n_load2*W_second)-C_d_second/C_l_second;

            %For Distances Calculation
            if S_g1+S_g3<0
                asd(j)=asd(j-1);
            else
                asd(j)=S_g1+S_g3;
            end
            if S_g1+S_g2+S_a<0
                tod(j)=tod(j-1);
            else             
                tod(j)=S_g1+S_g2+S_a;
            end
            angle2(j)=angle_second;
            W(j)=W_to;

            j=j+1;
        end
        %% For finding Optimum Distance

        %Checkpoint 
        diff1=(asd_given-asd)>0;
        if diff1==zeros(1,n_w)
            display('ASD not sufficient');
            break;
        end
        diff2=(tod_given-tod)>0;
        if diff2==zeros(1,n_w)
            display('TOD not sufficient');
            break;
        end
        diff3=(angle_secondseg-angle2)>0;
        if diff3==zeros(1,n_w)
            display('second segment angle not sufficient');
            break;
        end

        %finding optimum length
        p=find(asd_given-asd>0); %returns array of the positions
        q=find(tod_given-tod>0); %returns array of the positions
        r=find(angle_secondseg-angle2>0);
        u=max(p); %finding maximum postion for asd
        v=max(q); %finding maximum postion for tod
        w=max(r);

        %Assigning values among variables of OUTER LOOP
        W_asd(i)=W(u); %in X1000 Kgs
        W_tod(i)=W(v);
        W_angle2(i)=W(w);

        %Increasing loop number
        i=i+1;
    end

%% Plot subplots of various V_2/V_stall
subplot(2,2,k);
suptitle('Optimization of MTOW for various V_{2}/V_{stall}');
plot(v_ratio,per1000(N2kg(W_asd)));
hold all;
plot(v_ratio,per1000(N2kg(W_tod)));
plot(v_ratio,per1000(N2kg(W_angle2)),'--');
xlabel('V_{cr}/V_{r}');
ylabel('MTOW (1000 Kgs)');
title(sprintf('V_{2}/V_{stall} = %.2f', v2_ratio));
legend('ASD', 'TOD', 'Climb Angle 2^{nd} Segment');
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
k=k+1;

end


