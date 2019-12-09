% This function is the implementation of the measurement model.
% The bearing should be in the interval [-pi,pi)
% Inputs:
%           S(t)                           4XM
%           j                              1X1
% Outputs:  
%           h                              2XM
function z_j = observation_model(S, j)

    global map % map including the coordinates of all landmarks | shape 2Xn for n landmarks
    global M % number of particles

    % YOUR IMPLEMENTATION

    % The angle relative to the robot orientation theta.
    bearing = atan2(map(2, j)-S(2,:),map(1, j)-S(1,:))-S(3,:);
    
    % Mapping the angle into the range [-pi,pi]
    bearing = mod(bearing+pi,2*pi)-pi;
    
    % Distances to landmarks
    distance = sqrt((map(1, j)-S(1, :)).^2 +(map(2, j)-S(2, :)).^2);
    
    % Is this really z_j though? shouldnt it be called h?
    z_j = [distance;bearing];
end