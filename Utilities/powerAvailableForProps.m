%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%  To determine power available from turboprop is a bit tricky, lets be patient  %                                 %
%  power used                                                            %
%  still needs improvement; variation with speed need to be considered   %
%  rpm torque and power need to be restudied and properly modeled        %
%  power limit due to OAT not included                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[P_a,propellerEfficiency]=powerAvailableForProps(v,d,powerUsed)
global P_max d0
%P_max=0.9.*P_max.*(d/d0).^.728%from text nita
P_max2=0.932825.*P_max.*(d./d0).^0.739667; %Bruening 1992
%P_max=P_max.*(d/d0)^.765; %asselin/pg.no.59 %pistonprop
% rps_prop=powerUsed.*maximumRPS./gearRatio; %  rpm torque and power need to be restudied and properly modeled 
% J=v./(rps_prop.*propellerDiameter);
% if J==0
%     propellerEfficiency=0;
% elseif J<.1
%     propellerEfficiency=.1;
% elseif J<.2
%     propellerEfficiency=.3;
% elseif J<.3
%     propellerEfficiency=.5;
% elseif J<.4
%     propellerEfficiency=.6;
% elseif J<.5
%     propellerEfficiency=.72;
% elseif J<.6
%     propellerEfficiency=.78;
% else
%     propellerEfficiency=.859;
% end
propellerEfficiency=0.85;

P_a=propellerEfficiency.*powerUsed.*P_max2;

