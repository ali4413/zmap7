% translating.m

report_this_filefun(mfilename('fullpath'));
if isempty('ZG.newcat')== 1
    ZG.newcat=a;
end

% call
uiwait(dlboxb2p);               % way is now 'unif' or 'real'
if cancquest=='yes'; return; end; clear cancquest;

% call
uiwait(beta2prob_dlbox1);       % NuRep is now defined
if cancquest=='yes'; return; end; clear cancquest;
NuRep=str2double(NuRep);

BinLength=1/length(xt);
NuBins=length(xt);

% produce Big Catalog
if way=='unif'
    BigCatalog=sort(rand(100000,1));
else % if way=='real'
    whichs=ceil(length(ZG.newcat)*rand(100000,1)); % numbers in whichs from 1 to length(ZG.newcat)
    BigCatalog(100000,1)=0;
    for i=1:100000
        BigCatalog(i,1)=ZG.newcat(whichs(i),3);    % ith element of BigCatalog is random out of ZG.newcat
    end
    BigCatalog=sort(BigCatalog);
    BigCatalog=(BigCatalog-min(BigCatalog))/(max(BigCatalog)-min(BigCatalog));
end

% call
sim_2prob;


if value2trans=='zval'
    ProbValuesZ=[];
    for i=1:length(as)
        ProbValuesZ(1,i)=normcdf(as(1,i), IsFitted(2,1), IsFitted(2,2));
    end

else % i.e. if value2trans=='beta'
    ProbValuesBeta=[];
    for i=1:length(BetaValues)
        ProbValuesBeta(1,i)=normcdf(BetaValues(1,i), IsFitted(1,1), IsFitted(1,2));
    end
end


% plot
