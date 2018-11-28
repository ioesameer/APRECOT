%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
% Take input from users for different flap positions naming them as      %
% 1,2,3,4.... and the value of Cl_max for corresponding positions.      %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[Cl]=ClMaxFlap(flapAngle)
global angle_flapPosition0 angle_flapPosition1 angle_flapPosition2 angle_flapPosition3
global ClMax0 ClMax1 ClMax2 ClMax3
if flapAngle==angle_flapPosition0    
    Cl=ClMax0;
elseif flapAngle==angle_flapPosition1
    Cl=ClMax1;
elseif flapAngle==angle_flapPosition2
    Cl=ClMax2;
elseif flapAngle==angle_flapPosition3
    Cl=ClMax3;
elseif flapAngle==angle_flapPosition4
    Cl=ClMax4;
elseif flapAngle==angle_flapPosition5
    Cl=ClMax5;
end
    
