%% function to compute the "mass"

function M = mass_comp(V,mean_posterior,var_posterior,varargin)
M = 0;
global beta
% if nargin < 4
    for jj = 1:length(V(:,1))
        densitytemp = mean_posterior(V(jj,1),V(jj,2)) + beta*var_posterior(V(jj,1),V(jj,2));
        M = M + densitytemp;
    end
% else
%     for jj = 1:length(V(:,1))
%         densitytemp = mean_posterior(V(jj,1),V(jj,2)) + beta*var_posterior(V(jj,1),V(jj,2));
%         measurementprod = dist(V(jj,:),varargin{1});
%         M = M + measurementprod*densitytemp;
%     end
% end
end