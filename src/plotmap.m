report_this_filefun(mfilename('fullpath'));

figure


l  = get(h1,'XLim');
s1 = l(2); s2 = l(1);
l  = get(h1,'YLim');
s3 = l(2); s4 = l(1);

cl =  get(h1,'Clim');

m_proj('lambert','long',[s2 s1],'lat',[s4 s3]);

cstep = abs(cl(2) - cl(1))/50;
[m,c] = m_contourf(gx,gy,re4,(cl(1):cstep:cl(2)));
set(c,'LineStyle','none');

hold on

if isempty(coastline) ==  0
    lico = m_line(coastline(:,1),coastline(:,2),'color','k');
end

if isempty(faults) == 0
    lifa = m_line(faults(:,1),faults(:,2),'color','k');
end


m_grid('box','on','linestyle','none','tickdir','out','color','k','linewidth',1.5,...
    'fontsize',10,'fontname','Helveticabold');
hold on
shading flat
caxis([cl(1) cl(2)]);



hold on

%li = m_line(ZG.a.Longitude,ZG.a.Latitude);
%set(li,'Linestyle','none','Marker',ty1,'MarkerSize',ZG.ms6,'color',co)
set(gcf,'Color','w')

vx =  (cl(1):cstep:cl(2));
v = [vx ; vx]; v = v';
rect = [0.93 0.4 0.015 0.25];
axes('position',rect)
pcolor((1:2),vx,v)
shading flat
set(gca,'XTickLabels',[])
set(gca,'FontSize',10,'FontWeight','normal',...
    'LineWidth',1.0,'YAxisLocation','right',...
    'Box','on','SortMethod','childorder','TickDir','out')



