clc;
clear;
inputs;


%CURRENT INPUTS
v=120;
dT=0;
h=5000:25000;
d=density2(f2m(h),dT);
W=16000*9.8;

%CALCULATION
P=Power_req(v,d,W,0);


fuel=P.*c;
SR=v./fuel/1852;
SR_max=max(SR)
%SR_long_posn=find(abs(SR-.99*SR_max)<.001,2);
%SR_long=SR(SR_long_posn);
%v_SR_long=v(SR_long_posn)

%GRAPHS
plot(h,SR)

