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
%%
% Global variables are declared so that they can be used in each function
global flapType flapChordToWingChord flapAreaToWingArea  flapSpanToWingSpan fuselageDiameterToWingDiameter
global lambda Cd0 k 
%FOR PROFILE DRAG INCREMENT
%% plain flap
% k_profile is profile drag constant that is used to calculate profile drag
% increment
% The process below is done to change equation into usable form
% Reference is Jan Roskam VI

if strcmp(flapType,'plain') %to compare if flapType is plain flap
     if flapAngle<=7.5
        k_profile=0; %flapChordToWingChord=ratio of chord of flap to wing chord
  
    elseif flapAngle<=12.5
        k_profile=.05*flapChordToWingChord; 
  
    elseif flapAngle<=17.5
        k_profile=.1*flapChordToWingChord; 
  
     elseif flapAngle<=22.5
        k_profile=.15*flapChordToWingChord; 
        
     elseif flapAngle<=27.5
        k_profile=.2*flapChordToWingChord;
        
     elseif flapAngle<=32.5
        k_profile=.25*flapChordToWingChord; 
        
      elseif flapAngle<=37.5
        k_profile=.27*flapChordToWingChord; 
        
     else
        k_profile=.3*flapChordToWingChord; 
    end
    
end
%% split flap
if strcmp(flapType,'split')
     if flapAngle<=7.5
        k_profile=0; %flapChordToWingChord=ratio of chord of flap to wing chord
    
    elseif flapAngle<=12.5
        k_profile=.05*flapChordToWingChord;
  
    elseif flapAngle<=17.5
        k_profile=.1*flapChordToWingChord; 
  
     elseif flapAngle<=22.5
        k_profile=.16*flapChordToWingChord; 
        
     elseif flapAngle<=27.5
        k_profile=.24*flapChordToWingChord; 
        
     elseif flapAngle<=32.5
        k_profile=.3*flapChordToWingChord; 
        
      elseif flapAngle<=37.5
        k_profile=.36*flapChordToWingChord; 
        
      else
        k_profile=.42*flapChordToWingChord; 
      end
    
end
%% single slotted flap
if strcmp(flapType,'singleSlotted')
     if flapAngle<=7.5
        k_profile=0; %flapChordToWingChord=ratio of chord of flap to wing chord
    
    elseif flapAngle<=12.5
        k_profile=.003*flapChordToWingChord; 
  
    elseif flapAngle<=17.5
        k_profile=.0045*flapChordToWingChord; 
  
     elseif flapAngle<=22.5
        k_profile=.006*flapChordToWingChord; 
        
     elseif flapAngle<=27.5
        k_profile=.0075*flapChordToWingChord; 
        
     elseif flapAngle<=32.5
        k_profile=.01*flapChordToWingChord; 
        
      elseif flapAngle<=37.5
        k_profile=.014*flapChordToWingChord; 
        
     else
        k_profile=.018*flapChordToWingChord; 
     end
    
end
%% double slotted flap
if strcmp(flapType,'doubleSlotted')
   if flapAngle<=7.5
        k_profile=0; %flapChordToWingChord=ratio of chord of flap to wing chord
    
    elseif flapAngle<=12.5
        k_profile=.01*flapChordToWingChord; 
  
    elseif flapAngle<=17.5
        k_profile=.0125*flapChordToWingChord; 
  
     elseif flapAngle<=22.5
        k_profile=.015*flapChordToWingChord; 
        
     elseif flapAngle<=27.5
        k_profile=.0175*flapChordToWingChord; 
        
     elseif flapAngle<=32.5
        k_profile=.02*flapChordToWingChord; 
        
      elseif flapAngle<=37.5
        k_profile=.023*flapChordToWingChord; 
        
     else
        k_profile=.026*flapChordToWingChord; 
    end
    
end
%% Pofile drage increment
dCd_profile=k_profile*cosd(lambda)*flapAreaToWingArea; %profile drag increment

%% for induced drag increment
k_induced=(1.62-.6*flapSpanToWingSpan)*fuselageDiameterToWingDiameter/(1+fuselageDiameterToWingDiameter);
dCd_induced=k_induced^2*cosd(lambda)*((ClMaxFlap(flapAngle)-ClMaxFlap(0)))^2; %ClMaxFlap assigns maximum value of Cl according to flap position.
%% totalDragIncrement
dCd=dCd_profile+dCd_induced; %total increment in drag