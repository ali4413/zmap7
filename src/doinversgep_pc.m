%  doinvers
% This file calculates orintation of the stress tensor
% based on Gephard's algorithm.
% stress tensor orientation. The actual calculation is done
% using a call to a fortran program.
%
% Stefan Wiemer 03/96


global mi mif1 mif2  hndl3 a newcat2 mi2
global tmpi cumu2
fs = filesep;
report_this_filefun(mfilename('fullpath'));
think

hodis = fullfile(hodi, 'external');
do = ['cd  ' hodis ]; eval(do)

% prepare the focal; mechnism in Gephard format ...
tmp = [ZG.newt2(:,10:12) ];

try
    save data.inp tmp -ascii
catch ME
    error_handler(ME, ['Error - could not save file ', ZmapGlobal.Data.out_dir ,'data.inp - permission?']);
end

infi =  'data.inp';
outfi = 'tmpout.dat';
fid = fopen('inmifi.dat','w');
fprintf(fid,'%s\n',infi);
fprintf(fid,'%s\n',outfi);
fclose(fid);
comm = ['delete ' outfi];
eval(comm)

%unix(['.' fs 'datasetupDD < inmifi.dat ' ]);

%added support for multiple platforms de 07/2009
switch computer
    case 'GLNX86'
        [stat, res] = unix(['.' fs 'datasetupDD_linux < inmifi.dat ' ]);
    case 'MAC'
        %[stat, res] = unix(['.' fs 'slfast_macppc data2 ']);
        disp('PPC currently not supported')
    case 'MACI'
        [stat, res] = unix(['.' fs 'datasetupDD_maci < inmifi.dat ' ]);
    otherwise
        [stat, res] = dos(['.' fs 'datasetupDD.exe < inmifi.dat ' ]);
end



fid = (['tmpout.dat']);

format = ['%f%f%f%f%f'];
[d1 d2 d3 d4,  d5] = textread(fid,format,'headerlines',1); %Problem: "Errorlines" cause crashes.

dall = [d1 d2 d3 d4 d5];
n0 = [n 0];

fid = fopen('tmp.inp','w');
fprintf(fid,'%s\n',['  ' num2str(length(d1)) '  0']);
fprintf(fid,' %7.3f %6.3f %7.3f %6.3f %3.0f\n',dall');
fclose(fid);


disp('Now doing the approximate inversion ...')
%unix(['.' fs 'fmsi_ste < AP1.IN']);

%added support for multiple platforms de 07/2009
switch computer
    case 'GLNX86'
        [stat, res] = unix(['.' fs 'fmsi_ste_linux < AP1.IN']);
    case 'MAC'
        %[stat, res] = unix(['.' fs 'slfast_macppc data2 ']);
        disp('PPC currently not supported')
    case 'MACI'
        [stat, res] = unix(['.' fs 'fmsi_ste_maci < AP1.IN']);
    otherwise
        [stat, res] = dos(['.' fs 'fmsi_ste.exe < AP1.IN']);
end

disp('done...')

% load the results of the approximate inversion ...
clear tmp
load tmp
apres = tmp(end,:);

% create the EX1.IN file
fid = fopen('EX1.IN','w');
fprintf(fid,'%s\n','tmp.inp');
fprintf(fid,'%s\n','tmp3.out');
fprintf(fid,'%s\n','1');
fprintf(fid,'%s\n',[num2str(apres(1),3) ' ' num2str(apres(2),3) ' 30']);
fprintf(fid,'%s\n','n');
fprintf(fid,'%s\n',[num2str(apres(5),3) ' ' num2str(apres(6),3) ' 30']);
fprintf(fid,'%s\n','1');
fprintf(fid,'%s\n','0 1 .1');
fprintf(fid,'%s\n','3');
fclose(fid);

% do the exact inversion
disp('Now doing the exact inversion ...')

helpdlg('The inversion is running right now ... it will take a few minutes ... please wait until results appear ');
%unix(['.' fs 'fmsi_ste < EX1.IN']);

%added support for multiple platforms de 07/2009
switch computer
    case 'GLNX86'
        [stat, res] = unix(['.' fs 'fmsi_ste_linux < EX1.IN']);
    case 'MAC'
        %[stat, res] = unix(['.' fs 'slfast_macppc data2 ']);
        disp('PPC currently not supported')
    case 'MACI'
        [stat, res] = unix(['.' fs 'fmsi_ste_maci < EX1.IN']);
    otherwise
        [stat, res] = dos(['.' fs 'fmsi_ste.exe < EX1.IN']);
end


disp('done...! ')

% Now plot the results
n = ZG.newt2.Count;
load out95
f2 = out95;
fit = min(out95(:,9));
pai = atan(1.0)*4;
k = 4;
conf = 1.96;
li = (conf*sqrt((pai/2.0-1)*n)+n*1.0)*fit/((n-k)*1.0);
%li = prctile2(out95(:,9),1.0);
%li = 5
l = out95(:,9) <= li;
f = out95(l,:);

figure
wulff
hold on

X = [f(:,1) f(:,2) ];
theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
xp = rho .* cos(theta);
yp = rho .* sin(theta);
pl1 = plot(xp,yp,'ks');


X = [f(:,3) f(:,4) ];
theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
xp = rho .* cos(theta);
yp = rho .* sin(theta);
pl2 = plot(xp,yp,'r^');


X = [f(:,5) f(:,6) ];
theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
xp = rho .* cos(theta);
yp = rho .* sin(theta);
pl3 = plot(xp,yp,'bo');


set(pl1,'LineWidth',1,'MarkerSize',4,'Markerfacecolor','w')
set(pl2,'LineWidth',1,'MarkerSize',4,'Markerfacecolor','w')
set(pl3,'LineWidth',1,'MarkerSize',4,'Markerfacecolor','w')

le = legend([pl1 pl2 pl3],'S1','S2','S3');

set(le,'pos',[0.1 0.8 0.15 0.1]);
set(le,'Xcolor','w','ycolor','w','box','off');

% Plot the best solution
i =  min(find(f(:,9) == min(f(:,9))));

X = [f(i,1) f(i,2) ];
theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
xp = rho .* cos(theta);
yp = rho .* sin(theta);
pl = plot(xp,yp,'ks');
set(pl,'LineWidth',2,'MarkerSize',12,'Markerfacecolor','w')
hold on

X = [f(i,3) f(i,4) ];
theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
xp = rho .* cos(theta);
yp = rho .* sin(theta);
pl = plot(xp,yp,'k^');
set(pl,'LineWidth',2,'MarkerSize',12,'Markerfacecolor','w')

X = [f(i,5) f(i,6) ];
theta = pi*(90-X(:,2))/180;      %az converted to MATLAB angle
rho = tan(pi*(90-X(:,1))/360);   %projected distance from origin
xp = rho .* cos(theta);
yp = rho .* sin(theta);
pl = plot(xp,yp,'ok');
set(pl,'LineWidth',2,'MarkerSize',12,'Markerfacecolor','w')
set(gcf,'color','w');

axes('pos',[0 0 1 1 ]);
axis off

text(0.01,0.25,['R: ' num2str(f(i,8),2) ]);
text(0.01,0.22,['Misfit: ' num2str(f(i,9),2) ]);
text(0.01,0.18,['Phi: ' num2str(f(i,7),2) ]);
text(0.01,0.14,['S1: trend: ' num2str(f(i,1),4) '; plunge: '  num2str(f(i,2),4) ]);
text(0.01,0.1,['S2: trend: ' num2str(f(i,3),4) '; plunge: '  num2str(f(i,4),4) ]);
text(0.01,0.06,['S3: trend: ' num2str(f(i,5),4) '; plunge: '  num2str(f(i,6),4) ]);

% Determine the faulting style based on Zoback, 1992

%return
ste = [f(i,1) f(i,2)+180 f(i,3) f(i,4)+180 f(i,5) f(i,6)+180];

type = 'Unknow'; n = 1;
if ste(n,1) > 52 & ste(n,5) < 35 ; type = 'Normal'; end
if ste(n,1) > 40 & ste(n,1) <  52 & ste(n,5) < 20 ; type = 'Normal to Strike Slip';  end
if ste(n,1) < 40 & ste(n,3)> 45 & ste(n,5) < 20 ; type = 'Strike Slip';  end
if ste(n,1) < 20 & ste(n,3)> 45 & ste(n,5) < 40 ; type = 'Strike Slip'; end
if ste(n,1) < 20 & ste(n,5)> 40 & ste(n,5) < 20 ; type = 'Thrust to Strike Slip'; l4 = pl; end
if ste(n,1) < 35 & ste(n,5)> 52  ; type = 'Thrust';  end

text(0.01,0.02,['Faulting style: ' type]);

uicontrol('Units','normal',...
    'Position',[.4 .0 .1 .04],'String','Info ',...
     'Callback',' web http://www-wsm.physik.uni-karlsruhe.de/pub/data_details/regime.html ');

