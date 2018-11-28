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
function[P_r]=powerRequired(v,d,W,flapAngle) 
global S
liftCoefficient=Cl(W,d,v);
dragCoefficient=CdFlap(flapAngle,liftCoefficient);
thrustRequired=.5.*d.*v.^2.*S.*dragCoefficient;
P_r= thrustRequired.*v;
end
