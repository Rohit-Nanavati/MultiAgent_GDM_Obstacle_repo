%% function to compute the "mass"

function [M,Cv] = m_cv_gen(V,density)
M = 0;
Cv = [0 0];
    for jj = 1:length(V(:,1))
        M = M + density(V(jj,2),V(jj,1));
    end
    for jj = 1:length(V(:,1))
        Cv = Cv + [V(jj,1) V(jj,2)]*density(V(jj,2),V(jj,1));
    end
    Cv = Cv/M;
end