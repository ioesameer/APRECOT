%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%  Function that calculates Power and thrust from velocity,density and   %                                 %
%  power used                                                            %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[T_a]=thrustAvailable(v,d,n_pu)
global P_max d0 
%P_max=0.9.*P_max.*(d/d0).^.728%from text nita
P_max=0.932825*P_max*(d/d0).^0.739667; %Bruening 1992
%P_max=P_max.*(d/d0)^.765; %asselin/pg.no.59 %pistonprop
n_pr=.85;
% rps_prop=n_pu.*maximumRPS./gearRatio;
% J=v./(rps_prop.*prop_dia);
% if J==0
%     n_pr=0;
% elseif J<.1
%     n_pr=.1;
% elseif J<.2
%     n_pr=.3;
% elseif J<.3
%     n_pr=.5;
% elseif J<.4
%     n_pr=.6;
% elseif J<.5
%     n_pr=.72;
% elseif J<.6
%     n_pr=.78;
% else
%     n_pr=.86;
% end
P_a=n_pr.*n_pu.*P_max;
T_a=P_a./v;
