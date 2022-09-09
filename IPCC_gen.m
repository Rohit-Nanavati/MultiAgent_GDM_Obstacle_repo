function Agnt_pos = IPCC_gen(VSet,Agnt_pos,density,robotspeed)
    NoA = length(Agnt_pos);
    Qs = 1;
    v = 0.5;
    tau = 250;
    sigma = 100;
    lam = sqrt(sigma*tau/(1 + 0.25*v^2*tau/sigma));
    theta = 0;
    fdash = zeros(NoA,2);
    
    for noa = 1:NoA
        for jj = 1:length(VSet{noa}(:,1))
            error = Agnt_pos(noa,:) - VSet{noa}(jj,:);
            if norm(error)>0
                f1 = error/(Qs*norm(error) + norm(error)^2);
                f2 = (0.5*v/sigma)*[cosd(theta) sind(theta)];
                f3 = error/(lam*norm(error));
                fdash(noa,:) = fdash(noa,:) + (f1 + f2 + f3)*density(VSet{noa}(jj,2),VSet{noa}(jj,1));
            end
        end
        fdash(noa,:) = fdash(noa,:)/norm(fdash(noa,:));
    end
    
    Agnt_pos = Agnt_pos - robotspeed*fdash;
end