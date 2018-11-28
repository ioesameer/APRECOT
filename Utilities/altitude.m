function[h1,T]=altitude(d)
global d0 T0 R_gas a_atm R_earth g0

h0=0;
T=T0*(d./d0).^(-a_atm*R_gas./(g0+a_atm*R_gas));
h2=h0+(T-T0)./a_atm;
h1=h2*R_earth./(R_earth-h2);
