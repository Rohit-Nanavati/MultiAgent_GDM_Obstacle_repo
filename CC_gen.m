function Agnt_pos = CC_gen(VSet,Agnt_pos,density,robotspeed)
    NoA = length(Agnt_pos);
    fad = zeros(NoA,2);
    for noa = 1:NoA
        [mass(noa),centroid(noa,:)] = m_cv_gen(VSet{noa},density);
        fad(noa,:) = (Agnt_pos(noa,:) - centroid(noa,:))/norm(Agnt_pos(noa,:) - centroid(noa,:));
    end
    Agnt_pos = Agnt_pos - robotspeed*fad;
end