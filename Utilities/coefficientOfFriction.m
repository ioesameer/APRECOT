%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APRECOT)                                 %
%________________________________________________________________________%
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% For calculating coefficient of friction
global tyrePressure

%% Conditions Applied
if tyrePressure<=50
    fun=@(v) -.0350.*(v./100).^3+.306.*(v./100).^2-.851.*(v./100)+.883;
    u_r=integral(fun,0,50);
    u_r=u_r/500;
end

if tyrePressure>50&&tyrePressure<=100
    fun=@(v) -.0437.*(v./100).^3+.320.*(v./100).^2-.805.*(v./100)+.804;
    u_r=integral(fun,0,50);
    u_r=u_r/500;
end

if tyrePressure>100&&tyrePressure<=200
    fun=@(v) -.0331.*(v./100).^3+.252.*(v./100).^2-.658.*(v./100)+.692;
    u_r=integral(fun,0,50);
    u_r=u_r/500;
end


if tyrePressure>=300
    fun=@(v) -.0401.*(v./100).^3+.263.*(v/100).^2-.611.*(v./100)+.614;
    u_r=integral(fun,0,50);
    u_r=u_r/500;
end
