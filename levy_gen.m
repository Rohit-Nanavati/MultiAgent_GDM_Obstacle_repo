function Agnt_pos = levy_gen(Agnt_pos,InpDom)
    NoA = length(Agnt_pos);
    randwalk = levy(5,2,1.4);
    Agnt_pos_temp1 = Agnt_pos + randwalk;
    Agnt_pos_temp2 = Agnt_pos - randwalk;
    for counter = 1:NoA
        if inpolygon(Agnt_pos_temp1(counter,1),Agnt_pos_temp1(counter,2),InpDom(:,1),InpDom(:,2)) == 1
            Agnt_pos(counter,:) = Agnt_pos(counter,:) + randwalk(counter,:);
        elseif inpolygon(Agnt_pos_temp2(counter,1),Agnt_pos_temp2(counter,2),InpDom(:,1),InpDom(:,2)) == 1
            Agnt_pos(counter,:) = Agnt_pos(counter,:) - randwalk(counter,:);
        end
    end
end