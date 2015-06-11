function stopdata = SD1analyze_p2(trialseq)

% intialize
id = SD1columns;
symbols = unique(trialseq(:,id.symb));

% group trials
stoptrials = trialseq(trialseq(:,id.ssig) == 1,:);
misstrials = trialseq((trialseq(:,id.ssig) == 0 & trialseq(:,id.resp) == 0),:);
nonmisstrials = trialseq((trialseq(:,id.ssig) == 1 | trialseq(:,id.resp) > 0),:);
nostoptrials = trialseq(trialseq(:,id.ssig) == 0,:);
misstrials = nostoptrials(nostoptrials(:,id.resp) == 0,:);
gotrials = nostoptrials(nostoptrials(:,id.resp) > 0,:);
corgotrials = gotrials(gotrials(:,id.qdrn)==gotrials(:,id.resp),:);
errgotrials = gotrials(gotrials(:,id.qdrn)~=gotrials(:,id.resp),:);
failstoptrials = stoptrials(stoptrials(:,id.accu) == 3,:);
succstoptrials = stoptrials(stoptrials(:,id.accu) == 4,:);

% numbers
stopdata.numbers.all = size(trialseq,1);
stopdata.numbers.go.all = size(nostoptrials,1);
stopdata.numbers.go.cor = size(corgotrials,1);
stopdata.numbers.go.miss = size(misstrials,1);
stopdata.numbers.go.err = size(errgotrials,1);
stopdata.numbers.stop.all = size(stoptrials,1);
stopdata.numbers.stop.fail = size(failstoptrials,1);
stopdata.numbers.stop.succ = size(succstoptrials,1);

% percentages
stopdata.rates.miss = 100*stopdata.numbers.go.miss / stopdata.numbers.go.all;
stopdata.rates.err = 100*stopdata.numbers.go.err / stopdata.numbers.go.all;
stopdata.rates.stop = 100*stopdata.numbers.stop.all / stopdata.numbers.all;
stopdata.rates.stopsucc.all = 100*stopdata.numbers.stop.succ / stopdata.numbers.stop.all;

% RT (in ms)
stopdata.RT.cor = mean(corgotrials(:,id.RT))*1000;
stopdata.RT.err = mean(errgotrials(:,id.RT))*1000;
stopdata.RT.failstop = mean(failstoptrials(:,id.RT))*1000;

% SSRT
ssrtmat = zeros(size(nonmisstrials,1),4); % preassign
ssrtmat(:,[1 2]) = [nonmisstrials(:,id.RT)*1000 nonmisstrials(:,id.accu)]; % insert RT/accuracy
for it = 1:size(nonmisstrials,1) % go through trials
    ssrtmat(it,4) = nonmisstrials(it,id.qdrn)-4; % insert staircase (l/r)
    ssrtmat(it,3) = nonmisstrials(it,id.ssig+ssrtmat(it,4)); % insert SSD value
end
scs = unique(ssrtmat(ssrtmat(:,4)>0,4)); % get all staircases
scSSD = zeros(length(scs),1);
% get SSD mean of all staircases
for is = 1:numel(scs)
    sctrials = ssrtmat(ssrtmat(:,4)==is,:);
    scSSD(is,1) = nanmean(sctrials(:,3));
end
% store
stopdata.ssrt.mSSD = mean(scSSD);
stopdata.ssrt.SSRT = stopdata.RT.cor - stopdata.ssrt.mSSD;

% some data for individual symbols
for is = 1:length(symbols)
    
    % select symboltrials
    symbtrials = trialseq(trialseq(:,id.symb) == symbols(is),:);
    
    % group
    nostoptrials = symbtrials(symbtrials(:,id.ssig) == 0,:);
    gotrials = nostoptrials(nostoptrials(:,id.resp) > 0,:);
    stoptrials = symbtrials(symbtrials(:,id.ssig) == 1,:);
    failstoptrials = stoptrials(stoptrials(:,id.resp) > 0,:);
    succstoptrials = stoptrials(stoptrials(:,id.resp) == 0,:);
    
    % measurements
    meanRT = mean(gotrials(:,id.RT))*1000;
    stopsucc = 100*size(succstoptrials,1) / size(stoptrials,1);
    
    % store
    eval(['stopdata.RT.symbols.s' num2str(symbols(is)) ' = meanRT;']);
    eval(['stopdata.rates.stopsucc.symbols.s' num2str(symbols(is)) ' = stopsucc;']);

end
