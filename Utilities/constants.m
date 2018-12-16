%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APRECOT)                                 %
%________________________________________________________________________%
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global g p0 d0 T0 R_gas a_atm R_earth g0
g0= 9.8065; %acceleration due to gravity
g=9.80665; %acceleration due to gravity and is used where the variable g is reserved for other value of 'g'
p0=101325; %value of pressure at sea level
d0=1.225; %value of density at sea level
T0=288.16; %reference value of temperature
R_gas=286.9; %value of gas constant for air
a_atm=-6.5/1000; %a= lapse rate, unit=celcius/metre
R_earth=6371000; %radius of earth