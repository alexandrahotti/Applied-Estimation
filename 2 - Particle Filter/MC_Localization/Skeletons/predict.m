% This function performs the prediction step.
% Inputs:
%           S(t-1)            4XN
%           v                 1X1
%           omega             1X1
% Outputs:   
%           S_bar(t)          4XN
function [S_bar] = predict(S, v, omega, delta_t)

    % Comment out any S_bar(3, :) = mod(S_bar(3,:)+pi,2*pi) - pi before
    % running the test script as it will cause a conflict with the test
    % function. If your function passes, uncomment again for the
    % simulation.

    global R % covariance matrix of motion model | shape 3X3
    global M % number of particles
    
    % YOUR IMPLEMENTATION
    N = size(S, 2);
    theta = S(3,:);
    omega_vector = omega*ones(1, M);
    
    u_bar = [v*cos(theta); v*sin(theta); omega_vector; zeros(1,M)]*delta_t;
    
    % Sampling random noise.
    random_noise = randn(N, 3) * R;
    
    % Add an extra column for the weights
    weight_vector = zeros(N, 1);
    noise = [random_noise weight_vector];
    
    S_bar = S + u_bar + noise';
    
end