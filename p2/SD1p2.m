function trialseq = SD1p2(settings);

% initiate
id = SD1columns(0);

% shorten
OW = settings.screen.ow;
OWD = settings.screen.owd;

% make sequence
trialseq = SD1p2randomize(settings);

% make first stimulus
it = 1;
stimuluscommand = SD1stimulus(settings,trialseq(it,:));

% go through sequence
while it <= size(trialseq,1)

    % fixation
    eval(settings.commands.stopfix);
    [timestamp trialbegin] = Screen('Flip', OW); % update screen
    WaitSecs(settings.duration.fix);
    
    % display stimulus
    eval(stimuluscommand);
    eval(settings.commands.stopfix);
    [timestamp starttime] = Screen('Flip', OW); % update screen
    
    % STOP
    if trialseq(it,id.ssig) == 1
        % wait for response before stop signal
        SSD = trialseq(it,id.lSSD-1+trialseq(it,id.qdrn)-length(settings.learning.magnitudes));
        [trialseq(it,id.resp),trialseq(it,id.RT)] = SD1response(settings,starttime,SSD/1000);
        % display stopsignal
        eval(settings.commands.stop);
        % wait for response after stop signal
        if trialseq(it,id.resp) == 0
            [trialseq(it,id.resp),trialseq(it,id.RT)] = SD1response(settings,starttime,settings.duration.stopstim);
        end
	% GO
    elseif trialseq(it,id.ssig) == 0
        [trialseq(it,id.resp),trialseq(it,id.RT)] = SD1response(settings,starttime,settings.duration.stopstim);
    end
    
    % assess accuracy
    eval(stimuluscommand);
    eval(settings.commands.stopfix);
    Screen('Flip', OW); % flip empty
    WaitSecs(settings.duration.stopstim - (GetSecs - starttime));
    trialseq = SD1p2accuracy(settings,trialseq,it);
    
    % make next stimulus    
    it = it + 1;
    if it <= size(trialseq,1)
        stimuluscommand = SD1stimulus(settings,trialseq(it,:));
    end
    
    % ITI
    eval(settings.commands.stopfix);
    Screen('Flip', OW); % flip empty
    WaitSecs(settings.duration.stoptrial - (GetSecs - starttime));
    
    % BLOCKFEEDBACK
    if it-1 == size(trialseq,1) || trialseq(it-1,id.bloc) ~= trialseq(it,id.bloc)
        if settings.training == 0
            SD1p2blockfeedback(settings,trialseq,it-1);
        end
    end
    
end
