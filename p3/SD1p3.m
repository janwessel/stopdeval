function [trialseq,settings] = SD1p3(settings)

% initialize
id = SD1columns;

% shorten
OW = settings.screen.ow;
OWD = settings.screen.owd;

% make sequence
trialseq = SD1p3sequence(settings);

% make first stimulus
it = 1;
stimuluscommand = SD1stimulus(settings,trialseq(it,:));

% go through sequence
while it <= size(trialseq,1)

    % fixation
    eval(settings.commands.betfix);
    [timestamp trialbegin] = Screen('Flip', OW); % update screen
    WaitSecs(settings.duration.fix);
    
    % throw up symbol
    eval(stimuluscommand);
    Screen('Flip', OW); % update screen
    WaitSecs(settings.duration.betdelay);
    
    % add bids and buttons
    eval(stimuluscommand);
    if strcmpi(settings.betting.type,'6keys')
        SD1p3bidcommand(settings,trialseq(it,:));
    else SD1p3bidcommand(settings,trialseq(it,:),0); % l/r selection
    end
    [timestamp starttime] = Screen('Flip', OW); % update screen
    
    % response
    if strcmpi(settings.betting.type,'6keys') % standard
        [trialseq(it,id.resp),trialseq(it,id.RT)] = SD1response(settings,starttime,settings.duration.betstim);
    else 
        [trialseq(it,id.resp),trialseq(it,id.RT)] = SD1p3select(settings,starttime,settings.duration.betstim,stimuluscommand,trialseq,it);
    end
    
    % store
    if trialseq(it,id.resp) > 0
        trialseq(it,id.bpic) = trialseq(it,id.bopt-1+trialseq(it,id.resp)); % which amount?
        sizeoptions = sort(trialseq(it,id.bopt:id.bopt+settings.betting.stepsize-1));
        trialseq(it,id.blev) = find(sizeoptions==trialseq(it,id.bpic)); % which level?
        it = it+1;
    else % too slow
        Screen('FillPoly',OW,[0 0 0],[OWD(3)*5/12 OWD(4)*1/3; OWD(3)*5/12 OWD(4)*2/3;OWD(3)*7/12 OWD(4)*2/3;OWD(3)*7/12 OWD(4)*1/3]);
        DrawFormattedText(OW, 'Too slow!', 'center', 'center', settings.layout.redcolor); % set text
        Screen('Flip', OW); % flip
        WaitSecs(settings.duration.reward/2);
        trialseq(it,id.pres) = trialseq(it,id.pres) + 1;
    end
    
    % blockfeedback
    if it > 1
        if it-1 == size(trialseq,1) || (trialseq(it-1,id.bloc) ~= trialseq(it,id.bloc) && trialseq(it,id.pres) == 1)
            SD1p3blockfeedback(settings,trialseq,it-1);
        end
    end

    % make next stimulus    
    if it < size(trialseq,1)
        stimuluscommand = SD1stimulus(settings,trialseq(it,:));
    end
    
    % ITI
    Screen('Flip', OW); % flip empty
    WaitSecs(settings.duration.bettrial - (GetSecs - trialbegin));
    
end
