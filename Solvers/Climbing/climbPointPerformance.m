%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
% Note: If an airplane flies at constant IAS then 1/2*density*v^2 is                                                                        %
% constant. So, Cl is also constant which means Drag is also constant.                                                                       %
% But, Power required is product of Drag and velocity. This velocity is
% in fact True Airspeed. Thats why I think it is needed to convert IAS to 
% TAS before sending it for calculation.
% Note: add variable to the name of variable if it matches with function                                                                       %
%       add output for output variable                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Preprocessing
format long g
clc;
clear;

% GLOBAL VARIABLES
global d0;

% Import data from library
aircraft;

% %% CURRENT INPUTS
% weight=5600; % input in kg
% height=2000; % input in ft
% inputVelocity=160; % input climb IAS in kts
% powerUsedFraction=.5; %in terms of full power
% dT=0; %ISA+ temperature
% loadFactor=1; %load factor
% flapAngle=0;%flap position, deg

% IMPORT FROM FILE
inputFileName='climbPointInputs.txt';
readFromFile % Now read data with readData(n), where n represents the line number of input data.

% ASSIGN VARIABLE NAMES
weight= readData(1)*g;
height= feet2meter(readData(2));
inputVelocity= knots2meter(readData(3));
powerUsedFraction= readData(4); %in terms of full power
dT=readData(5);
loadFactor= readData(6);
flapAngle= readData(7);
ceilingRateOfClimb=feet2meter(readData(8)/60);

% CALCULATIONS
d=density2(height,dT);
trueVelocity=cas2tas(inputVelocity,d); %true velocity
[theta,ROC]=rateOfClimb(d,trueVelocity,weight,powerUsedFraction,flapAngle);

% OUTPUTS
densityVariable=d;
trueVelocityOutput=meter2knots(trueVelocity); %in knots
stallVelocityVariable=stallVelocity(flapAngle,d,weight,loadFactor); %true
trueStallVelocity=meter2knots(stallVelocityVariable);
angleOfClimb=rad2deg(theta);
rateOfClimbVariable=ROC*197; %ft/min

%WRITING IN FILE
outputFilename='ClimbPointOutputs.txt';
densityVariable
rateOfClimbVariable
fid=fopen(outputFilename,'w');
fprintf(fid,'Density = %f \n',densityVariable);
fprintf(fid,'True Air Speed = %f \n',trueVelocityOutput);
fprintf(fid,'Stall Velocity = %f \n',stallVelocityVariable);
fprintf(fid,'True Stall Velocity = %f \n',trueStallVelocity);
fprintf(fid,'Angle of Climb = %f \n',angleOfClimb);
fprintf(fid,'Rate of Climb = %f \n',rateOfClimbVariable);




%% FOR MAXIMUMS (CALCULATION)
velocityRange=30:150; % TAS in m/s

% For Rate of Climb
[theta,ROC]=rateOfClimb(d,velocityRange,weight,powerUsedFraction,flapAngle);
horizontalVelocity=velocityRange.*cos(theta);

[maximumRateOfClimb,i]=max(ROC);
angleForMaxROC=theta(i);
velocityForMaxROC=velocityRange(i);
  if velocityForMaxROC<stallVelocityVariable
      velocityForMaxROC=stallVelocityVariable;
      [angleForMaxROC,maximumRateOfClimb]=rateOfClimb(d,stallVelocityVariable,weight,powerUsedFraction,flapAngle);
  end
  
% For Angle of Climb
[maximumAngleOfClimb,j]=max(theta);
velocityForMaxAOC=velocityRange(j);
ROCForMaxAOC=ROC(j);
if maximumAngleOfClimb<stallVelocityVariable
    velocityForMaxAOC=stallVelocityVariable;
    [maximumAngleOfClimb, ROCForMaxAOC]=rateOfClimb(d,stallVelocityVariable,weight,powerUsedFraction,flapAngle);
end

%WRITING IN FILE
fprintf(fid,'Maximum rate of Climb = %f ft per minutes \n',maximumRateOfClimb*197)
fprintf(fid,'Velocity for maximum Rate of Climb = %f knots\n',meter2knots(velocityForMaxROC))
fprintf(fid,'Angle for Maximum Rate of Climb = %f degrees \n',rad2deg(angleForMaxROC))
fprintf(fid,'Maximum Angle of Climb = %f degrees \n',rad2deg(maximumAngleOfClimb))
fprintf(fid,'Velocity for maximum Angle of Climb = %f knots\n',meter2knots(velocityForMaxAOC))
fprintf(fid,'Rate of Climb for maximum Angle of Climb = %f feet per minutes\n',ROCForMaxAOC*197)
fclose(fid)

% FOR VARIATION OF ALTITUDE (CALCULATIONS)
altitudeStep=500;
altitudeRange=1:altitudeStep:10000; % in meters
ROCwithAltitude=zeros(1,numel(altitudeRange));
AOCwithAltitude=zeros(1,numel(altitudeRange));
for i=1:numel(altitudeRange)
densityForAltitude=density2(altitudeRange(i),dT);
trueVelocity=cas2tas(inputVelocity,densityForAltitude); % TAS in m/s
[AOCwithAltitude(i),ROCwithAltitude(i)]=rateOfClimb(densityForAltitude,trueVelocity,weight,powerUsedFraction,flapAngle);
end

%FOR VARIATION OF ALTITUDE (OUTPUTS)
opr_ceiling=meter2feet(altitudeRange(find(ROCwithAltitude<ceilingRateOfClimb,1))) % in ft

% % GRAPHS
% figure(1)
% plot(meter2knots(velocityRange),ROC*197);
% hold all;
% plot(stallVelocity_TAS*ones(1,numel(velocityRange)),ROC*197);
% xlabel('TAS (kts)');
% ylabel('Rate of Climb (ft/min)');
% title(sprintf('Rate of Climb vs Velocity (TAS) at Pressure Altitude = %.0f ft', meter2feet(h)));
% legend('Rate of climb', 'Stall Velocity Line');
% grid on;
% set(gca,'XMinorTick','on');
% set(gca,'YMinorTick','on');
% 
% figure(2)
% plot(meter2knots(v_hor),ROC*197);
% xlabel('Horizontal Velocity (kts)');
% ylabel('Rate of Climb (ft/min)');
% title(sprintf('Hodograph for Climb at Pressure Altitude = %.0f ft', meter2feet(h)));
% grid on;
% set(gca,'XMinorTick','on');
% set(gca,'YMinorTick','on');
% 
% figure(3)
% plot(meter2knots(velocityRange),rad2deg(theta));
% hold all;
% plot(stallVelocity_TAS*ones(1,numel(velocityRange)),rad2deg(theta));
% xlabel('TAS (kts)');
% ylabel('Angle of Climb (deg)');
% title(sprintf('Angle of Climb vs Horizontal Velocity for Climb at Pressure Altitude = %.0f ft', meter2feet(h)));
% legend('Angle of Climb', 'Stall Velocity Line');
% grid on;
% set(gca,'XMinorTick','on');
% set(gca,'YMinorTick','on');
% 
% figure(4)
% plot(per1000(meter2feet(h_alt)),ROC_alt*197)
% xlabel('Pressure Altitude (1000 ft)');
% ylabel('Rate of Climb (ft/min)');
% title(sprintf('Rate of Climb vs Pressure Altitude for Climb at Velocity (IAS) = %.0f kts', meter2knots(v)));
% grid on;
% set(gca,'XMinorTick','on');
% set(gca,'YMinorTick','on');
