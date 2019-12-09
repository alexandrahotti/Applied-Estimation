% This function performs the ML data association
%           S_bar(t)                 4XM
%           z(t)                     2Xn
%           association_ground_truth 1Xn | ground truth landmark ID for
%           every measurement
% Outputs: 
%           outlier                  1Xn
%           Psi(t)                   1XnXM
function [outlier, Psi, c] = associate_old(S_bar, z, association_ground_truth)
    if nargin < 3
        association_ground_truth = [];
    end

    global DATA_ASSOCIATION % wheter to perform data association or use ground truth
    global lambda_psi % threshold on average likelihood for outlier detection
    global Q % covariance matrix of the measurement model
    global M % number of particles
    global N % number of landmarks
    global landmark_ids % unique landmark IDs
    

    
    % YOUR IMPLEMENTATION
    no_obs = size(z, 2); 
    z_bar = zeros(2, M, N);
    
    % Precition step
    for j = 1 : N
    z_bar(:, :, j) = observation_model(S_bar, j);
    end
    
    z_bar_org = z_bar;
    z_org = z;
    z = repmat(z(:),1,M*N);
    z_bar = repmat(reshape(z_bar,2,M*N),5,1);
    
    nu = z - z_bar;
    % bearings = nu(2:2:end,:);
    % distances = nu(1:2:end,:); 
    % Map every other row (the bearings) to [-pi, pi]
    nu(2:2:end,:) = mod(nu(2:2:end,:) + pi, 2*pi) - pi;
    
    norm = (1/(sqrt(det(Q))*pi*2));
    
    Q_matrix = repmat(diag(Q), no_obs, M*N);
    
   
    exponent_terms = (nu.^2).* Q_matrix;
    
    %sum the terms so that we get one value for each observation. 
    bearing_terms = exponent_terms(2:2:end,:);
    distances_terms = exponent_terms(1:2:end,:); 
    
    exponent_observation_terms = bearing_terms + distances_terms;
    
    
    likelihood_exponent_matrix = norm*exp((-0.5)*exponent_observation_terms);
    
    c = zeros(no_obs, M);
    Psi = zeros(no_obs, M);
    outlier = zeros(1,no_obs);
    
    for j = 1 : no_obs
        
        likelihoods_obs_j = reshape(likelihood_exponent_matrix(j,:),10,1000);
        [likelihood_values, k] = max(likelihoods_obs_j);
        
        c(j,:) = k;
        Psi(j,:) = likelihood_values;
        
        outlier(j) = (sum(likelihood_values)/M)<=lambda_psi;
    end
    
    Psi = reshape(Psi,1,no_obs,M);
    outlier = reshape(outlier,1,no_obs);
    
    
end