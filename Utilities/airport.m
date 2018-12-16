%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APRECOT)                                 %
%________________________________________________________________________%
% Inputs for Airport                                                     %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toda=3050; %takeoff distance available
asda=3050; %accelerate stop distance available
thirdSegmentHeight=f2m(500); %third segment acceleration height above airport STANDARD IS 400
airportHeight=1338; % Elevation of the airport. It is 1338 metre for TIA
runwaySlope=0; %in degree positive for upward
secondSegmentAngle=1.2; %in degree
fourthSegmentAngle=1.2; %in degree
firstObstacleDistance=1060; % in meter
firstObstacleHeight=305; % in meter
