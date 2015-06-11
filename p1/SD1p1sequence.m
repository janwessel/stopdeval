function [trialseq,settings] = SD1p1sequence(settings);

% initialize
id = SD1columns;

if settings.training == 1
    
    symbols(1:7,id.symb) = 0;
    symbols(1:7,id.magn) = 100;
    symbols(1:7,id.stop) = 0;
    symbols(1:7,id.qdrn) = [1 4 2 4 1 2 3];
    
else

    % MAKE SYMBOLS
    for im = 1:length(settings.learning.magnitudes)
        sample = [];
        if strcmpi(settings.learning.distribution,'normal')
            while round(mean(sample)) ~= settings.learning.magnitudes(im) || round(std(sample)) ~=settings.learning.parameter
                sample = round(settings.learning.magnitudes(im)+settings.learning.parameter.*randn(settings.learning.trials,1));
            end
        elseif strcmpi(settings.learning.distribution,'uniform')
            gof = 0;
            while round(mean(sample)) ~= settings.learning.magnitudes(im) || gof < .8
                sample = round(settings.learning.magnitudes(im)+settings.learning.parameter.*((rand(settings.learning.trials,1)-0.5)*2));
                
                % test GOF
                bins = linspace(settings.learning.magnitudes(im)-settings.learning.parameter, settings.learning.magnitudes(im)+settings.learning.parameter,11);
                expected = repmat(length(sample) / (length(bins)-1),1,length(bins));
                for ib = 2:length(bins)
                    observed(ib) = sum(sort(sample) < bins(ib)) - sum(sort(sample) < bins(ib-1));
                    chi(ib) = (observed(ib) - expected(ib)).^2 / expected(ib);
                end
                chi = sum(chi(2:end));
                gof = 1-chi2cdf(chi,length(bins)-2);
            end
        else error(['Unknown distribution: ' settings.learning.distribution ]);
        end
        symbols(im,:) = sample;
    end
    symbols = repmat(symbols,2,1); % replicate for second set of symbols
    symbols = reshape(symbols,numel(symbols),1); % make column vector
    symbols(:,id.symb) = repmat([1:length(settings.learning.magnitudes)*2]',settings.learning.trials,1);
    symbols(:,id.mags) = repmat([1:length(settings.learning.magnitudes)]',settings.learning.trials*2,1);
    symbols(:,id.stop) = repmat([zeros(length(settings.learning.magnitudes),1);ones(length(settings.learning.magnitudes),1)],settings.learning.trials,1);

    % QUADRANTS
    for is = 1:length(settings.learning.magnitudes)*2
        % make quadrant numbers
        if round(settings.learning.trials/length(settings.learning.magnitudes)) == settings.learning.trials/length(settings.learning.magnitudes)
            quadrants = repmat(1:length(settings.learning.magnitudes),1,round(settings.learning.trials/length(settings.learning.magnitudes)));
        else
            disp('Number of Trials not dividable by number of symbols: Quadrant probabilities will not be exactly equal.');
            quadrants = repmat(1:length(settings.learning.magnitudes),1,ceil(settings.learning.trials/length(settings.learning.magnitudes)));
            quadrants = quadrants(1:length(settings.learning.trials));
        end
        % shuffle
        quadrants = quadrants(randperm(settings.learning.trials));
        % insert
        symbols(symbols(:,2)==is,id.qdrn) = quadrants;
    end
    
    % NULLTRIALS
    zerotrials = [];
    if settings.learning.zerotrials > 0
        for im = 1:length(settings.learning.magnitudes)*2
            zerotrials1 = [];
            zerotrials1(:,[id.magn id.mags]) = repmat(0,2,settings.learning.zerotrials)';
            zerotrials1(:,id.symb) = im;
            for is = 1:settings.learning.zerotrials
                randq = randperm(4);
                qrdns(is) = randq(1);
            end
            zerotrials1(:,id.qdrn) = qrdns';
            if im > length(settings.learning.magnitudes)
                zerotrials1(:,id.stop) = 1;
            end
            zerotrials = [zerotrials; zerotrials1];
        end
    end
    symbols = [symbols; zerotrials];

    % SHUFFLE
    symbols = symbols(randperm(size(symbols,1)),:);

    % BLOCK
    blocktrials = size(symbols,1)/settings.learning.blocks;
    if round(blocktrials) ~= blocktrials
        disp('Overall trialnumber not divisable by block length. Appending excess trials to last block.');
        blocktrials = floor(size(symbols,1)/settings.learning.blocks);
    end
    for ib = 1:settings.learning.blocks
        symbols((ib-1)*blocktrials+1:(ib)*blocktrials,id.bloc) = ib;
    end
    if round(blocktrials) ~= blocktrials
        symbols((ib)*blocktrials+1:end,id.bloc) = ib;
    end

    % ASSIGN SYMBOLS AND COLORS
    syms = randperm(length(settings.learning.magnitudes)*2);
    cols = randperm(length(settings.learning.magnitudes)*2);
    for is = 1:length(settings.learning.magnitudes)*2
        symbols(symbols(:,2) == is,id.syml) = syms(is);
        symbols(symbols(:,2) == is,id.symc) = cols(is);
        settings.symbols.layout(is) = syms(is);
        settings.symbols.colors(is) = cols(is);
    end

end
symbols(:,id.pres) = 1;
trialseq = symbols;
