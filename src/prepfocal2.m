% prepfocal
% to prepare the events for inversion based
% on Lu Zhongs code.

report_this_filefun(mfilename('fullpath'));

think
tmp = [ZG.newt2(:,10:12)];
do = ['save ' ZmapGlobal.Data.out_dir 'data.inp tmp -ascii'];
err =  ['Error - could not save file ' ZmapGlobal.Data.out_dir 'data.inp - permission?'];
err2 = ['errordlg(err);return'];
eval(do,err2)

infi = [ZmapGlobal.Data.out_dir 'data.inp'];
outfi = [ZmapGlobal.Data.out_dir 'tmpout.dat'];
outfi2 = [ZmapGlobal.Data.out_dir 'tmpout2.dat'];


fid = fopen([ZmapGlobal.Data.out_dir 'inmifi.dat'],'w');

fprintf(fid,'%s\n',infi);
fprintf(fid,'%s\n',outfi);

fclose(fid);
comm = ['!/bin/rm ' outfi];
eval(comm)

comm = ['!  ' hodi '/stinvers/datasetupDD < ' ZmapGlobal.Data.out_dir 'inmifi.dat ' ]
eval(comm)

comm = ['!grep  "1.0" ' outfi  '>'  outfi2];
eval(comm)

comm = ['load ' ZmapGlobal.Data.out_dir 'tmpout2.dat'];
eval(comm)

%l = ZG.newt2(:,length(ZG.newt2(1,:)));
%a(:,10:13) = [];
%a = [a  tmpout2  l tmp];

done
