function [respkey,RT] = SD1p3select(settings,starttime,duration,stimuluscommand,trialseq,it)            

% initialize
OW = settings.screen.ow;
confirmflag = 0; respkey = 0; RT = 0; % preassign
DisableKeysForKbCheck('empty'); % disable fMRI trigger

% get initial position
selected = randperm(settings.betting.stepsize); selected = selected(1); % initial selection
eval(stimuluscommand); SD1p3bidcommand(settings,trialseq(it,:),selected); % make display
Screen('Flip', OW); % throw on screen

while (GetSecs - starttime) <= duration && confirmflag == 0

    % check
    [keytoggle, endtime, keycode] = KbCheck(-1);
    selectflag = 0;
    
    % this if loop gets response, otherwise keeps checking
    if keycode(settings.buttons.nw)==1
        DisableKeysForKbCheck(find(keycode)); % disable key
        RT = endtime - starttime;
        respkey = selected;
        confirmflag = 1; selectflag = 0;
        Screen('Flip', OW); 
        break
    elseif keycode(settings.buttons.ne)==1
        DisableKeysForKbCheck(find(keycode)); % disable key
        RT = endtime - starttime;
        respkey = selected;
        confirmflag = 1; selectflag = 0;
        Screen('Flip', OW); 
        break
    elseif keycode(settings.buttons.se)==1
        DisableKeysForKbCheck(settings.buttons.se); % disable key
        selected = selected + 1;
        selectflag = 1;
    elseif keycode(settings.buttons.sw)==1
        DisableKeysForKbCheck(settings.buttons.sw); % disable key
        selected = selected - 1;
        selectflag = 1;
    end
    
    % change selection
    if selectflag == 1
        
        % rectify out of bounds bids for display
        if selected < 1; selected = 1; end
        if selected > settings.betting.stepsize; selected = settings.betting.stepsize; end
        eval(stimuluscommand); SD1p3bidcommand(settings,trialseq(it,:),selected); % make display
        Screen('Flip', OW); % throw on screen
        
        % prevent overload
        while keytoggle == 1; WaitSecs(0.1); keytoggle = KbCheck(-1); end
        DisableKeysForKbCheck('empty'); % enable all keys
        
    end

    WaitSecs(0.001); % prevent overload
end
