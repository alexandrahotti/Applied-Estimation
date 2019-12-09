% This function calcultes the weights for each particle based on the
% observation likelihood
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs: 
%           S_bar(t)            4XM
function S_bar = weight(S_bar, Psi, outlier)

    % YOUR IMPLEMENTATION

      %Remove outliers.
      likelihoods = Psi(:,outlier<1,:);
      
      % Log the likelihoods before multiplying them to avoid underflow.
      log_likelihoods = log(likelihoods);
      
      % Multiply likelihoods over the observations.
      log_likelihood_product = sum(log_likelihoods, 2);
      
      % Un-log the likelihoods.
      likelihood_product = exp(log_likelihood_product);
      
      % Store and normalize the new weights in the state.
      S_bar(4,:) = likelihood_product / sum(likelihood_product);
      
end
