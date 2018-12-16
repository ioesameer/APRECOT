%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%  endurance anderson                                                    %
%  non design parameter is given zero input                              %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[Endu,h,v,C_l]=Endurance(W0,W1,C_l,h,v)
inputs
n_pr=0.85;% take input of best propeller efficiency
if C_l==0 % h and v given
    d=density(h,0);
    %find instantanneous value of W;
    C_l=C_l(v,d,W);
    C_d=C_d_flap(0,C_l)%flap position 0;
    Endu=n_pr/c*sqrt(2*d*S)*C_l^1.5/C_d*(W1^(-.5)-W0^(-.5));
elseif h==0 % C_l and v given
    C_d=C_d_flap(0,C_l)%flap position 0;
    d=2*W/(v^2*C_l*S);
    Endu=n_pr/c*sqrt(2*d*S)*C_l^1.5/C_d*(W1^(-.5)-W0^.5)
    h=altitude(d);
elseif v==0 %C_l and h given
    d=density(h,0);
    %find instantanneous value of W;
    C_d=C_d_flap(0,C_l)%flap position 0;
    Endu=n_pr/c*sqrt(2*d*S)*C_l^1.5/C_d*(W1^(-.5)-W0^.5);
    v=sqrt(2*W/(d*S*C_l));
end