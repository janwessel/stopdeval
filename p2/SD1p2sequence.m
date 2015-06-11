function trialseq = SD1p2sequence(settings);

% initialize
id = SD1columns;

if settings.training == 1
    
    trialseq(1:10,id.symb) = 0;
    trialseq(1:10,id.mags) = 0;
    trialseq(1:10,id.ssig) = [0 1 0 0 1 0 1 0 0 1];
    trialseq(1:10,id.qdrn) = [5 6 5 5 6 5 6 6 6 5];
    trialseq(1:10,id.lSSD:id.rSSD) = 200;
    
else

    % GET SYMBOL INFO
    symbols = settings.symbols.layout;
    colors = settings.symbols.colors;
    nsymbols = length(settings.learning.magnitudes)*2;
    % MAKE SYMBOLS
    trialseq(:,id.symb) = repmat([1:nsymbols]',settings.stopping.trials,1);
    trialseq(:,id.mags) = repmat([1:nsymbols/2]',settings.stopping.trials*2,1);
    trialseq(:,id.stop) = repmat([zeros(length(settings.learning.magnitudes),1);ones(length(settings.learning.magnitudes),1)],settings.stopping.trials,1);
    % Layout
    for is = 1:length(settings.learning.magnitudes)*2
        trialseq(trialseq(:,2)==is,id.syml) = symbols(is);
        trialseq(trialseq(:,2)==is,id.symc) = colors(is);
    end

    % SIDES
    for is = 1:length(settings.learning.magnitudes)*2
        % make side numbers
        if round(settings.stopping.trials/2) == settings.stopping.trials/2
            sides = repmat(1:2,1,round(settings.stopping.trials/length(settings.learning.magnitudes)*2));
        else
            disp('Number of Trials not divisable by number of trialseq: Quadrant probabilities will not be exactly equal.');
            sides = repmat(1:length(settings.learning.magnitudes),1,ceil(settings.stopping.trials/length(settings.learning.magnitudes)));
            sides = sides(1:length(settings.stopping.trials));
        end
        % shuffle
        sides = sides(randperm(settings.stopping.trials));
        % insert
        trialseq(trialseq(:,2)==is,id.qdrn) = sides+4;
    end

    % STOP SIGNAL
    for is = 1:length(settings.learning.magnitudes)*2
        if mean(trialseq(trialseq(:,2)==is,id.stop)) == 1 % high prob
            stoptrials = ceil(settings.stopping.trials*settings.stopping.prob(2));
        elseif mean(trialseq(trialseq(:,2)==is,id.stop)) == 0 % low prob
            stoptrials = ceil(settings.stopping.trials*settings.stopping.prob(1));
        end
        inserttrials = [ones(stoptrials,1); zeros(settings.stopping.trials-stoptrials,1)];
        trialseq(trialseq(:,id.symb)==is,id.ssig) = inserttrials;
    end

    % SSD
    trialseq(:,id.lSSD:id.rSSD) = settings.stopping.SSD;

    % SHUFFLE
    trialseq = trialseq(randperm(size(trialseq,1)),:);

    % BLOCK
    blocktrials = size(trialseq,1)/settings.stopping.blocks;
    if round(blocktrials) ~= blocktrials
        disp('Overall trialnumber not divisable by block length. Appending excess trials to last block.');
        blocktrials = floor(size(trialseq,1)/settings.stopping.blocks);
    end
    for ib = 1:settings.stopping.blocks
        trialseq((ib-1)*blocktrials+1:(ib)*blocktrials,id.bloc) = ib;
    end
    if round(blocktrials) ~= blocktrials
        trialseq((ib)*blocktrials+1:end,id.bloc) = ib;
    end
    
end
