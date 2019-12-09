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
    z_bar = zeros(2, M, N);
    
    
    % Precition step
    for j = 1 : N
    z_bar(:, :, j) = observation_model(S_bar, j);
    end
    
    nu_x = zeros(1,1000,10);
    c = zeros(no_obs, M);
    Psi = zeros(1, no_obs, M);
    outlier = zeros(1, no_obs);
    
    for x = 1 : no_obs
        obs_x = z(:,x);
        
        z_matrix = repmat(obs_x,1,M,N);
        
        
        %nu_x = z_matrix - z_bar;
        nu_x(1,:,:) = z(1,x) - z_bar(1, :, :);
        nu_x(2,:,:) = z(2,x) - z_bar(2, :, :);
        nu_x(2,:,:) = mod( nu_x(2,:,:) + pi, 2*pi) - pi;
         
        
        norm = (2*pi*( sqrt( det(Q) ) ))^(-1);
    
%         Q_matrix = repmat(diag(Q),1,M,N);
%         exponent_terms = (nu_x.^2).* Q_matrix;
        
        Q_matrix2 = repmat(diag(Q), [1, M, N]);
        
        psi = norm*(squeeze(exp(sum(-0.5.*nu_x.*Q_matrix2.*nu_x, 1))));
        
        [Psi(1,x,:), c(x,:)] = max(psi,[],2);
%         
%         bearing_terms = exponent_terms(2,:,:);
%         distances_terms = exponent_terms(1,:,:);
%         
%         exponent_observation_terms = bearing_terms + distances_terms;
%         likelihood_exponent_matrix = squeeze(norm*exp((-0.5)*exponent_observation_terms));
%         
%         [likelihood, inds] = max(likelihood_exponent_matrix,[], 2);
%         
%         c(x,:) = inds;
%         Psi(x,:) = likelihood;
%         
%         outlier(x) = (sum(likelihood)/M)<=lambda_psi;
    end
    disp('hej');
    outlier = (mean(squeeze(Psi),2) <=lambda_psi)';
    
    
end