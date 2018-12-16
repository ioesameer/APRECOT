%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%     rate of climb anderson                                             %
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[thita,ROC]=rateOfClimb(d,v,W,n_pu,flapAngle)% velocity is IAS m/s height in metre weight in newton dT in celcius and power used in %

%CALCULATION
thita=SET(v,d,n_pu,W,flapAngle);
ROC=SEP(v,d,n_pu,W,flapAngle);

