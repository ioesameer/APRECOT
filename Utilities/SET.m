%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%   A function to find Specefic Excess Power of the airplane             %
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[x]=SET(v,d,n_pu,W,flapAngle)
T_a=thrustAvailable(v,d,n_pu);
T_r=thrustRequired(v,d,W,flapAngle);
x=(T_a-T_r)./W;