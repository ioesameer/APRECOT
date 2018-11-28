%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%  function to find stall velocity                                       %
%  need to be revised                                                    %
%  linear interpolation                                                  %
%  effect of flap position need to be known                              %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[v]=stallVelocity(flapAngle,d,W,loadFactor)
global S
C_l=ClMaxFlap(flapAngle);
v=sqrt(2.*loadFactor.*W./(d*S*C_l));