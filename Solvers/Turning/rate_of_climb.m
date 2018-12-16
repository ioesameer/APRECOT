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
function[thita,ROC]=rate_of_climb(d,v,W,n_pu,n_flap)% velocity is IAS m/s height in metre weight in newton dT in celcius and power used in %

%CALCULATION
thita=SET(v,d,n_pu,W,n_flap);
ROC=SEP(v,d,n_pu,W,n_flap);

