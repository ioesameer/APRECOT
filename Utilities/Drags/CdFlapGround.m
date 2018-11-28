%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool            %
%                              (APCOT)                                    %
%_________________________________________________________________________%
% increase in Cd0 due to flap is not properly accounted  although appro-  %
% ximate eqn is found in literature in Loftin(1980)                                      %
%                                                                         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function[Cd]=CdFlapGround(flapAngle,Cl,W) 
global b wingHeight Cd0 S k angle_flapPosition0 angle_flapPosition1 angle_flapPosition2 angle_flapPosition3 g 
%%
% For Increment due to landing gear
% The value of landing gear constant varies from 5.81*10^-5 to 3.16*10^-5 for no flap and full flap respectively
% Following section does assigns approximate value of the constant for different flap position
if flapAngle==angle_flapPosition0
    landingGearConstant=5.81*10^-5;
end

if flapAngle==angle_flapPosition1
    landingGearConstant=4.93*10^-5;
end

if flapAngle==angle_flapPosition2
    landingGearConstant=4*10^-5;
end

if flapAngle==angle_flapPosition3
    landingGearConstant=3.16*10^-5;
end 
%%
% Now increment in drag due to landing gear is calculated
landingGearIncrement=(W./S).*landingGearConstant.*power(W./g,-.215)%change in drag coefficient due to landing gear

%% This statement calls the dragIncrement script that returns increment in profile drag and induced drag
dragIncrement % It provides dCd as the increment in drag

%% Incorporation of ground effect

temp= 16.*wingHeight/b; %temp= temporary variable
groundEffectConstant=(temp.^2)/(1+temp.^2);%ground effect
Cd=Cd0+landingGearIncrement+dCd+(groundEffectConstant.*k).*Cl.^2 % This is taken from Anderson eq no 6.78.
%In Anderson, k is separated as k1, k2 and k3 which are constant related to profile
%drag, wave drag and induced drag (eqn 2.46). For simplicity the landing gear constant
%is multiplied with induced drag constant directly
