%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Aircraft Performance Calculation and Optimization Tool           %
%                              (APCOT)                                   %
%________________________________________________________________________%
%    Anderson                                                            %
%                                                                        %
%                                                                        %
%                                                                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[R_min,w_max]=rate_of_turn_best(d,n_pu,W,n_flap)
inputs;
v=v_stall(n_flap,d,W,1);

%for minimum radius

for i=1:30
    T_a=Thrust_avai(v,d,n_pu);
    v=sqrt(4*k*(W/S)/(d*T_a/W));

end
n_r_min=sqrt(2-4*k*C_d0/(T_a/W)^2);
R_min=4*k*(W/S)/(g*d*T_a/W*sqrt(1-4*k*C_d0/(T_a/W)^2));
C_l_r_min=2*n_r_min*W/(d*v^2*S);
if C_l_r_min>C_l_max_flap(0)
    v=85;
    n_r_min=2.4
    [R_min,~]=rate_of_turn(v,n_r_min);
end

   
% for maximum turn rate
v=sqrt(2*W/S/d)*(k/C_d0)^.25;
T_a=Thrust_avai(v,d,n_pu);
n_w_max=sqrt(T_a/W/sqrt(k*C_d0)-1);
w_max=g*sqrt(n_w_max^2-1)/v;
if C_l_r_min<C_l_max_flap(0)
    v=85;
    n_r_min=2.4;
    [~,w__max]=rate_of_turn(v,n_r_min);
end
    