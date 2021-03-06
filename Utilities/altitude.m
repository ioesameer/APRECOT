%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APRECOT)                                 %
%________________________________________________________________________%
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[h1,T]=altitude(d)
%% Declaration of global variables
% For meaning of the variable look at file named "constants.m" in utilities directory
global d0 T0 R_gas a_atm R_earth g0


%% Start of Actual code
% Reference for following section is NPTEL lecture 2 in the Reference directory
h0=0; %Reference altitude
T=T0*(d./d0).^(-a_atm*R_gas./(g0+a_atm*R_gas));
h2=h0+(T-T0)./a_atm;
h1=h2*R_earth./(R_earth-h2);
