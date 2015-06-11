function learndata = SD1analyze_p1(trialseq);

% initialize
id = SD1columns;

% rate of errors and misses
learndata.errmissrate = 100*(sum(trialseq(:,id.pres)) - size(trialseq,1)) / size(trialseq,1);

% RT (ms)
learndata.RT.all = 1000*mean(trialseq(:,id.RT));

% individual symbol RT (ms)
symbols = unique(trialseq(:,id.symb));
for is = 1:length(symbols)
    % select
    symboltrials = trialseq(trialseq(:,id.symb) == symbols(is),:);
    % store
    eval(['learndata.RT.symbols.s' num2str(symbols(is)) ' = mean(symboltrials(:,id.RT))*1000;']);
end

% blocks
blocks = unique(trialseq(:,id.bloc));

% go through blocks
for ib = 1:length(blocks)
    %select
    blocktrials = trialseq(trialseq(:,id.bloc)==blocks(ib),:);
    % store
    eval(['learndata.RT.blocks.b' num2str(blocks(ib)) ' = mean(blocktrials(:,id.RT))*1000;']);
end
