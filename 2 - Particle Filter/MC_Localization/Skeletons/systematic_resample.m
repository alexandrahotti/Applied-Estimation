% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = systematic_resample(S_bar)
	
    global M % number of particles 
    
    % YOUR IMPLEMENTATION
    weights = S_bar(4,:);
    CDF = cumsum(weights);
    % Draw one single random sample from a uniform distribution for one
    % particle.
    r = ((1/M) - 0) * rand(1,1) + 0;
    
    S = zeros(4, M);
    
    for m = 1:M
        % Smallest weight greater than r
        ind_sample = find(CDF >= r ,1,'first');
        
        S_sample = zeros(4, 1);
        
        % Store the pose of the re-sampled particle.
        S(1:3, m) = S_bar(1:3, ind_sample);
        
        % Give all re-sampled particles uniform weight.
        S(4, m) = 1/M;
        
        % Update r.
        r = r + (1/M);
    end
end