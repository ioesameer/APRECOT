function[Endu,v]=Endurance_best(W0,W1,h)
inputs
d=density(h);
n_pr=0.8;
E=1/4*(3/(k*C_d0^(1/3)))^(3/4);
v=(2/d*sqrt(k/(3*C_d0))*W/S)^.5;`
Endu=n_pr/c*sqrt(2*d*S)*E*(W1^(-.5)-W0^.5);
