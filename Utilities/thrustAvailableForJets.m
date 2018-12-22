function[thrust]=thrustAvailableForjets(machNumber,altitude,powerUsed)
global T_max d0
%% This is derived from anderson's book pg.no 175 fig 3.20 
a = 9.5421523425597732E-01;
b = -3.2198266816167068E-02;
c = -1.2340629401979117E+00;
d = 3.1627661748201419E-04;
f = 7.4680720623432983E-01;
g = 1.0990270928063737E-02;

thrustRatio = a + b*altitude + c*machNumber + d*altitude^2 + f*machNumber^2 + g*altitude*machNumber;
thrust= T_max*thrustRatio;
