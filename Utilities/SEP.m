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
function[x]=SEP(v,d,n_pu,W,flapAngle)
P_a=powerAvailable(v,d,n_pu);
P_r=powerRequired(v,d,W,flapAngle);
x=(P_a-P_r)/W;