%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%  error occured when logical operator OR is used so if is used twice    %
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[Cd,E]=CdFlap(flapAngle,Cl)
global Cd0 k 
%flapAngle value used in dcd_flap
dragIncrement;
Cd=Cd0+dCd+k.*Cl.^2;
E=Cl./Cd;
