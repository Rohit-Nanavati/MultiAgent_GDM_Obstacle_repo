%%sweep trajectory
Agnt_pos = [Xmsweep(inst,1) Ymsweep(inst,1);
            Xmsweep(inst,2) Ymsweep(inst,2);
            Xmsweep(inst,3) Ymsweep(inst,3);
            Xmsweep(inst,4) Ymsweep(inst,4);
            Xmsweep(inst,5) Ymsweep(inst,5)];

APos_vec(:,:,inst+1) = Agnt_pos;
inst = inst + 1;