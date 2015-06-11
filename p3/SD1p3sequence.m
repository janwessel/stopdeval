function trialseq = SD1p3sequence(settings);

% initialize
id = SD1columns;

% GET SYMBOL INFO
symbols = settings.symbols.layout;
colors = settings.symbols.colors;
nsymbols = length(settings.learning.magnitudes)*2;

% MAKE SYMBOLS
trialseq(:,id.symb) = repmat([1:nsymbols]',settings.betting.trials,1);
trialseq(:,id.mags) = repmat([1:nsymbols/2]',settings.betting.trials*2,1);
trialseq(:,id.stop) = repmat([zeros(length(settings.learning.magnitudes),1);ones(length(settings.learning.magnitudes),1)],settings.betting.trials,1);
% Layout
for is = 1:length(settings.learning.magnitudes)*2
    trialseq(trialseq(:,2)==is,id.syml) = symbols(is);
    trialseq(trialseq(:,2)==is,id.symc) = colors(is);
end

% SIDES
trialseq(:,id.qdrn) = 7; % always center

% BETTING OPTIONS
clear bets
for is = 1:length(settings.learning.magnitudes)*2 % go through symbols
    
        % make options
        for il = 1:settings.betting.levels
            bets(il,:) = settings.betting.start+il*settings.betting.scalingfactor-1:settings.betting.start+il*settings.betting.scalingfactor-1:(settings.betting.start+il*settings.betting.scalingfactor-1)*settings.betting.stepsize;
            bets1(il,:) = bets(il,randperm(settings.betting.stepsize));
            bets2(il,:) = bets(il,randperm(settings.betting.stepsize));
        end
        bets = [bets1; bets2];
        % insert
        trialseq(trialseq(:,id.symb) == is,id.bopt:id.bopt-1+size(bets,2)) = bets;
    
end

% SHUFFLE
trialseq = trialseq(randperm(size(trialseq,1)),:);

% BLOCK
blocktrials = size(trialseq,1)/settings.betting.blocks;
if round(blocktrials) ~= blocktrials
    disp('Overall trialnumber not divisable by block length. Appending excess trials to last block.');
    blocktrials = floor(size(trialseq,1)/settings.betting.blocks);
end
for ib = 1:settings.betting.blocks
    trialseq((ib-1)*blocktrials+1:(ib)*blocktrials,id.bloc) = ib;
end
if round(blocktrials) ~= blocktrials
    trialseq((ib)*blocktrials+1:end,id.bloc) = ib;
end
trialseq(:,id.pres) = 1;
