%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
% To calculate density according to altitude                             %
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[d1,T]=density(geometricHeight)%geometricHeight geometric and h is geopotential

global  p0 d0 T0 R_gas a_atm R_earth g0

h0=0;
geopotentialHeight= geometricHeight.*(R_earth./(R_earth+geometricHeight));
T= T0+a_atm.*(geopotentialHeight-h0)
p1=p0*(T/T0).^(-g0/(a_atm*R_gas));%gradient
d1=d0*(T/T0).^-(g0/(a_atm*R_gas)+1);%gradient

