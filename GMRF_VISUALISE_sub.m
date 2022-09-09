function [f,d1,d2,d3,d4] = GMRF_VISUALISE_sub(Map,Density,handle,res,t)


% res = 0.05;
[row,col]=size(Map.pa);
for i=1:row
    for j=1:col
        x(i,j)=(j);
        y(i,j)=(i);
    end
end
n = 1; m = 4;
f = figure(handle); 
f.Units = 'normalized';
f.WindowState = 'maximized';

width = 0.325;
height = width;
left = -0.025;
bottom = 0.55;
s1 = subplot('Position',[left bottom width height]);
c1 = pcolor(x*res,y*res,Map.pa);
xlabel('$X$ [m]','interpreter','latex')
ylabel('$Y$ [m]','interpreter','latex')
title({'\textbf{Proposed algorithm}','Mean Estimate'},'interpreter','latex')
colorbar
colormap(flipud(hot))
set(c1, 'EdgeColor', 'none');
shading interp 
axis([0 6 0 6])
axis square

s2 = subplot('Position',[left+0.25 bottom width height]);
c2 = pcolor(x*res,y*res,Map.cvt);
xlabel('$X$ [m]','interpreter','latex')
ylabel('$Y$ [m]','interpreter','latex')
title({'\textbf{CVT}','Mean Estimate'},'interpreter','latex')
colorbar
colormap(flipud(hot))
set(c2, 'EdgeColor', 'none');
shading interp 
axis([0 6 0 6])
axis square

s3 = subplot('Position',[left+0.5 bottom width height]);
c3 = pcolor(x*res,y*res,Map.levy);
xlabel('$X$ [m]','interpreter','latex')
ylabel('$Y$ [m]','interpreter','latex')
title({'\textbf{Levy search}','Mean Estimate'},'interpreter','latex')
colorbar
colormap(flipud(hot))
set(c3, 'EdgeColor', 'none');
shading interp 
axis([0 6 0 6])
axis square

s4 = subplot('Position',[left+0.75 bottom width height]);
c4 = pcolor(x*res,y*res,Map.sweep);
xlabel('$X$ [m]','interpreter','latex')
ylabel('$Y$ [m]','interpreter','latex')
title({'\textbf{Sweep search}','Mean Estimate'},'interpreter','latex')
colorbar
colormap(flipud(hot))
set(c4, 'EdgeColor', 'none');
shading interp 
axis([0 6 0 6])
axis square

%% Density
bottom  = bottom - 0.45;
d1 = subplot('Position',[left bottom width height]); 
cd1 = pcolor(x*res,y*res,Density.pa); hold on;
% VoronoiLimit(agposhis_pa(:,1)*0.05,agposhis_pa(:,2)*0.05,'bs_ext',InpDom*0.05,'figure','on');
xlabel('$X$ [m]','interpreter','latex')
ylabel('$Y$ [m]','interpreter','latex')
title({'$\phi$, $\textbf{p}_i$'},'interpreter','latex')
colorbar
colormap(flipud(hot))
set(cd1, 'EdgeColor', 'none');
shading interp 
axis([-0.05 6.05 -0.05 6.05])
axis square

d2 = subplot('Position',[left+0.25 bottom width height]);
cd2 = pcolor(x*res,y*res,Density.cvt); hold on;
% VoronoiLimit(agposhis_cvt(:,1)*0.05,agposhis_cvt(:,2)*0.05,'bs_ext',InpDom*0.05,'figure','on');
xlabel('$X$ [m]','interpreter','latex')
ylabel('$Y$ [m]','interpreter','latex')
title({'$\phi$, $\textbf{p}_i$'},'interpreter','latex')
colorbar
colormap(flipud(hot))
set(cd2, 'EdgeColor', 'none');
shading interp 
axis([-0.05 6.05 -0.05 6.05])
axis square

d3 = subplot('Position',[left+0.5 bottom width height]);
cd3 = pcolor(x*res,y*res,Density.levy);
xlabel('$X$ [m]','interpreter','latex')
ylabel('$Y$ [m]','interpreter','latex')
title({'$\phi$, $\textbf{p}_i$'},'interpreter','latex')
colorbar
colormap(flipud(hot))
set(cd3, 'EdgeColor', 'none');
shading interp 
axis([-0.05 6.05 -0.05 6.05])
axis square

d4 = subplot('Position',[left+0.75 bottom width height]);
cd4 = pcolor(x*res,y*res,Density.sweep);
xlabel('$X$ [m]','interpreter','latex')
ylabel('$Y$ [m]','interpreter','latex')
title({'$\phi$, $\textbf{p}_i$'},'interpreter','latex')
colorbar
colormap(flipud(hot))
set(cd4, 'EdgeColor', 'none');
shading interp 
axis([-0.05 6.05 -0.05 6.05])
axis square

timetxt = ['Time = ',num2str(t),' s'];
sgt = sgtitle(timetxt,'EdgeColor','k');
sgt.FontSize = 20;
% suptitle(f,'time'); 
% view(2);
end

