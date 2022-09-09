%% Centroid_control
fad = zeros(NoA,2);
for noa = 1:NoA
    [mass(noa),centroid(noa,:)] = m_cv_gen(VSet{noa},density);
    fad(noa,:) = (Agnt_pos(noa,:) - centroid(noa,:))/norm(Agnt_pos(noa,:) - centroid(noa,:));
end
Agnt_pos = Agnt_pos - robotspeed*fad;
APos_vec(:,:,inst+1) = Agnt_pos;
inst = inst + 1;