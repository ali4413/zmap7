%   This subroutine "circle"  selects the Ni closest earthquakes
%   around a interactively selected point.  Resets ZG.newcat and ZG.newt2
%   Operates on "a".

%  Input Ni:
%
global dloop
ZG=ZmapGlobal.Data;
report_this_filefun(mfilename('fullpath'));

try
    delete(plos1)
catch ME
    error_handler(ME,@do_nothing);
end

axes(h1)
%zoom off

titStr ='Selecting EQ in Circles                         ';
messtext= ...
    ['                                                '
    '  Please use the LEFT mouse button              '
    ' to select the center point.                    '
    ' The "ni" events nearest to this point          '
    ' will be selected and displayed in the map.     '];

zmap_message_center.set_message(titStr,messtext);

% Input center of circle with mouse
%
[xa0,ya0]  = ginput(1);

stri1 = [ 'Circle: ' num2str(xa0,5) '; ' num2str(ya0,4)];
stri = stri1;
pause(0.1)
%  calculate distance for each earthquake from center point
%  and sort by distance
%
l = sqrt(((ZG.a.Longitude-xa0)*cosd(ya0)*111).^2 + ((ZG.a.Latitude-ya0)*111).^2) ;
[s,is] = sort(l);
newt2 = a(is(:,1),:) ;



l =  sort(l);
%


%% Sort by depth so ZG.newt2 can be divided into depth ratio zones
[s,is] = sort(ZG.newt2.Depth);
adepth = ZG.newt2(is(:,1),:);

if tgl1 == 0   % take point within r
    l3 = l <= ra;
    ZG.newt2 = ZG.newt2(l3,:);      % new data per grid point (b) is sorted in distanc  (from center point)
    circle_r = num2str(ra);
else
    ZG.newt2 = ZG.newt2(1:ni,:)
    circle_r = num2str(l(ni));
end

%% ZG.newt2 = ZG.newt2(1:ni,:);



messtext = ['Radius of selected Circle:' circle_r  ' km' ];
disp(messtext)
zmap_message_center.set_message('Message',messtext)

hold on

plot(ZG.newt2.Longitude,ZG.newt2.Latitude,'xk');

l = ZG.newt2.Depth >= top_zonet & ZG.newt2.Depth <  top_zoneb;
top_zone = ZG.newt2(l,:);

l = ZG.newt2.Depth >= bot_zonet & ZG.newt2.Depth <  bot_zoneb;
bot_zone = ZG.newt2(l,:);


ZG.hold_state=false ; dloop = 1;
bdiff_bdepth(top_zone);
ZG.hold_state=true; dloop = 2;
bdiff_bdepth(bot_zone);

set(gcf,'Pointer','arrow')

%
