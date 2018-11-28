%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[thrustRequired]=thrustRequired(v,d,W,flapAngle) 
global S
liftCoefficient=Cl(W,d,v);
dragCoefficient=CdFlap(flapAngle,liftCoefficient);
thrustRequired=.5.*d.*v.^2.*S.*dragCoefficient;
end
