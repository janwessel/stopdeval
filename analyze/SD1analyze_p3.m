function biddata = SD1analyze_p3(trialseq)

% initialize
id = SD1columns;
symbols = unique(trialseq(:,id.symb));

% cycle through symbols
for is = 1:length(symbols)
    
    % select trials
    symbtrials = trialseq(trialseq(:,id.symb) == symbols(is),:);
    ntrials = size(symbtrials,1);
    
    % amounts, levels, variance
    meanamount = mean(symbtrials(:,id.bpic));
    meanlevel = mean(symbtrials(:,id.blev));
    varlevel = var(symbtrials(:,id.blev));
    
    % rt
    meanRT = mean(symbtrials(:,id.RT));
    
    % store
    eval(['biddata.s' num2str(symbols(is)) '.RT = meanRT;']);
    eval(['biddata.s' num2str(symbols(is)) '.level = meanlevel;']);
    eval(['biddata.s' num2str(symbols(is)) '.amount = meanamount;']);
    eval(['biddata.s' num2str(symbols(is)) '.varlevel = varlevel;']);
    
    % store stopping info
    if is > 4
        eval(['biddata.s' num2str(symbols(is)) '.stop = 1;']);
    else
        eval(['biddata.s' num2str(symbols(is)) '.stop = 0;']);
    end
    
end

% compound values across symbols
biddata.valuestop = mean(trialseq(trialseq(:,id.stop)==1,id.blev));
biddata.valuenostop = mean(trialseq(trialseq(:,id.stop)==0,id.blev));
