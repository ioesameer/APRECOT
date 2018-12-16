%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APRECOT)                                 %
%________________________________________________________________________%
% Reference for this section is any book about flight dynamics           %
% Eg. Pamadi, Anderson                                                   %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[drag,E]=Cd(Cl)
global Cd0 k 
drag=Cd0+k.*Cl.^2;
E=Cl./drag;
