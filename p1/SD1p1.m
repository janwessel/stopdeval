function [trialseq,settings,failtrials] = SD1p1(settings);

% initialize
id = SD1columns;
failtrials.errortrials = [];
failtrials.errorRT = [];
failtrials.misstrials = [];

% shorten
OW = settings.screen.ow;
OWD = settings.screen.owd;
COL = settings.layout.fixcolor;

% make sequence
[trialseq,settings] = SD1p1sequence(settings);

% make first stimulus
it = 1;
stimuluscommand = SD1stimulus(settings,trialseq(it,:));

% go through sequence
while it <= size(trialseq,1)

    % fixation
    eval(settings.commands.fix);
    [timestamp trialbegin] = Screen('Flip', OW);
    WaitSecs(settings.duration.fix);
    
    % display stimulus
    eval(stimuluscommand);
    eval(settings.commands.fix);
    [timestamp starttime] = Screen('Flip', OW); % update screen
    
    % wait for correct response
    [trialseq(it,id.resp),trialseq(it,id.RT)] = SD1response(settings,starttime,settings.duration.learnstim);
    
    % evaluate response
    eval(stimuluscommand);
    [trialseq,it,failtrials] = SD1p1accuracy(settings,trialseq,it,failtrials);
    
    % blockfeedback
    if it > 1 && settings.training == 0
        if it-1 == size(trialseq,1) || (trialseq(it-1,id.bloc) ~= trialseq(it,id.bloc) && trialseq(it,id.pres) == 1)
                Screen('Flip', OW);
                WaitSecs(settings.duration.learntrial - (GetSecs - trialbegin)); % wait ITI
                SD1p1blockfeedback(settings,trialseq,it-1,failtrials);
        end
    end
    
    % prepare next stimulus    
    if it <= size(trialseq,1)
        stimuluscommand = SD1stimulus(settings,trialseq(it,:));
    end
    
    % ITI
    eval(settings.commands.fix); 
    Screen('Flip', OW);
    WaitSecs(settings.duration.learntrial - (GetSecs - trialbegin));

end
   
% reward
if settings.training == 0
    selector = randperm(size(trialseq,1)); selector = selector(1:5);
    settings.reward.learning = sum(trialseq(selector,id.magn));
end
