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
clc;
clear;
inputs;


%CURRENT INPUTS
for h=5000:5000:25000
v=60:150;
dT=0;
h=5000;
d=density2(f2m(h),dT);
W=16000*9.8;

%CALCULATION
P=Power_req(v,d,W,0);
SR2=C_l(W,d,v)/(c*W*C_d_flap(0,C_l(W,d,v)))

fuel=P.*c;
SR=v./fuel/1852;
SR_max=max(SR)
%SR_long_posn=find(abs(SR-.99*SR_max)<.001,2);
%SR_long=SR(SR_long_posn)
%v_SR_long=v(SR_long_posn)

%GRAPHS
plot(v,SR)
hold on
end

