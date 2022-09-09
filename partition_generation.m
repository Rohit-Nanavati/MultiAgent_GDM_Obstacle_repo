function [VSet0,V0,C0] = partition_generation(pos_x,pos_y,X,Y,InpDom,NoA)
    [V0,C0,XY0] = VoronoiLimit(pos_x,pos_y,'bs_ext',InpDom,'figure','off');
    VSet0 = cell([NoA,1]);
    for ii = 1:NoA
        in = inpolygon(X,Y,V0(C0{ii},1),V0(C0{ii},2));
        VSet0{ii} = [X(in) Y(in)];
    end
end