% This function performs the ML data association
%           S_bar(t)                 4XM
%           z(t)                     2Xn
%           association_ground_truth 1Xn | ground truth landmark ID for
%           every measurement
% Outputs: 
%           outlier                  1Xn
%           Psi(t)                   1XnXM
function [outlier, Psi, c] = associate(S_bar, z, association_ground_truth)

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
    c = zeros(1, no_obs, M); Psi = zeros(1, no_obs, M);
    z_bar = zeros(2, M, N); z_N_M = repmat(z, 1, 1, M, N);
    

    for j = 1 : N
       % z_bar(:, :, :, j) = permute(repmat(observation_model(S_bar, j), 1, 1, 1, no_obs), [1, 4, 3, 2]);
        z_bar(:, :, j) = observation_model(S_bar, j);
    end
    
    
    z_bar = permute(repmat(z_bar, 1, 1, 1, no_obs), [1 4 2 3]);
    
    nu(1,:,:,:) = z_N_M(1,:,:,:)- z_bar(1,:,:,:);
    nu(2,:,:,:) = mod( z_N_M(2,:,:,:)- z_bar(2,:,:,:) + pi, 2*pi) - pi;
    

    Q_diag = diag(Q);
    normalization_const = (2*pi*( sqrt( det(Q) ) ))^(-1);
    
    exponent_likelihood = (-1/2)*((Q_diag(1)^(-1)).*(nu(2,:,:,:).^2) + (Q_diag(2)^(-1)).*(nu(1,:,:,:).^2));
    likelihoods = normalization_const * exp(exponent_likelihood);
  
    max_dim = ndims(likelihoods);
    [max_likelihood, c_ind] = max(likelihoods, [], max_dim);
    
    
    c(1,:,:) = squeeze(c_ind); Psi(1,:,:) = squeeze(max_likelihood);
    
    mean_likelihood = mean(Psi, 3);
    thresholded_likelihood = lambda_psi >= mean_likelihood;
    outlier = ( thresholded_likelihood )';
end