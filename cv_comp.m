%% Centroid computation

function Cv = cv_comp(V,mean_posterior,var_posterior,Mv)
    global beta
    Cv = zeros(1,2);
     for jj = 1:length(V(:,1))
        densitytemp = mean_posterior(V(jj,1),V(jj,2)) + beta*var_posterior(V(jj,1),V(jj,2));
        Cv = Cv + (1/Mv)*V(jj,:)*densitytemp;
    end
end