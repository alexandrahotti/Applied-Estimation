% This function calculates the odometry information
% Inputs:
%           e_L(t):         1X1
%           e_R(t):         1X1
%           E_T:            1X1
%           B:              1X1
%           R_L:            1X1
%           R_R:            1X1
%           delta_t:        1X1
% Outputs:
%           v:              1X1
%           omega:          1X1
function [v, omega] = calculate_odometry(e_R, e_L, E_T, B, R_R, R_L, delta_t)

    if ~delta_t
        v = 0;
        omega = 0;
        return;
    end

    % YOUR IMPLEMENTATION %
    
    % The angular velocity omega.
    wRt = 2*pi*e_R / (delta_t*E_T);
    wLt = 2*pi*e_L /(delta_t*E_T);
    omega = (wRt*R_R - wLt*R_L) / B;
    
    % The translational velocity v.
    v = (wRt*R_R + wLt*R_L) / 2;

end