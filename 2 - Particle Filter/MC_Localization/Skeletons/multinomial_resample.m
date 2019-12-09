% This function performs multinomial re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = multinomial_resample(S_bar)

    global M % number of particles
    
    % YOUR IMPLEMENTATION
    weights = S_bar(4,:);
    CDF = cumsum(weights);
    % Draw one random sample form a uniform distribution for each
    % particle.
    r = rand(1,M);
    
    % New re-sampled particles.
    S = zeros(4, M);
   
    for m = 1:M
        
        % Smallest weight greater than r
        ind_sample = find(CDF >= r(m) ,1,'first');
        
        S_sample = zeros(4,1);
        
        % Store the pose of the re-sampled particle.
        S(1:3, m) = S_bar(1:3, ind_sample);
        
        % Give all re-sampled particles uniform weight.
        S(4, m) = 1/M;
        
    end

end
