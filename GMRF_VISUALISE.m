function GMRF_VISUALISE(map,handle,res)

% res = 0.05;
[row,col]=size(map);
% map=[map;zeros(col,1)'];
% map=[map,zeros(row+1,1)];
for i=1:row
    for j=1:col
        x(i,j)=(j);%*13-482;
        y(i,j)=(i);%*13-444;
        %z(i,j)=0;
    end
end

figure(handle)
c = pcolor(x*res,y*res,map);
xlabel('$X$ [m]','interpreter','latex')
ylabel('$Y$ [m]','interpreter','latex')
%set(gca,'YTick',[])
%set(gca,'XTick',[])
colorbar
% if ~isempty(limits)
%     caxis(limits)
% end
colormap(flipud(hot))
% colormap('jet')
% colormap(viridis());
set(c, 'EdgeColor', 'none');
shading interp 
% colorbar
% caxis([-5 5]);
% axis tight 
axis([0 6 0 6])
axis square
 view(2);
end

