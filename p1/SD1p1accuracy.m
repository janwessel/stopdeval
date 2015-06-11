function [trialseq,it,failtrials] = SD1p1accuracy(settings,trialseq,it,failtrials);

% initialize
id = SD1columns;
OW = settings.screen.ow;
OWD = settings.screen.owd;

% access accuracy
eval(settings.commands.fix);
Screen('TextSize',OW,settings.layout.introsize);
if trialseq(it,id.resp) ~= 0
    if trialseq(it,id.resp) == trialseq(it,id.qdrn) % correct
        % make amount string
        amount = trialseq(it,id.magn)/100;
        amount = num2str(amount);
        if isempty(strfind(amount,'.'))
            amount = [amount '.00'];
        else
            if length(amount) - strfind(amount,'.') == 1
                amount = [amount '0'];
            end
        end
        % make square overlay with amount string
        Screen('FillPoly',OW,[0 0 0],[OWD(3)*5/12 OWD(4)*1/3; OWD(3)*5/12 OWD(4)*2/3;OWD(3)*7/12 OWD(4)*2/3;OWD(3)*7/12 OWD(4)*1/3]);
        DrawFormattedText(OW, 'You win:', 'center', OWD(4)/2 - 100, settings.layout.fixcolor); % set text
        Screen('TextSize',OW,settings.layout.pointsize);
        DrawFormattedText(OW, ['$' num2str(amount)], 'center', 'center', settings.layout.fixcolor); % set text
        Screen('TextSize',OW,settings.layout.introsize);
        it = it + 1;
    else % error
        Screen('FillPoly',OW,[0 0 0],[OWD(3)*5/12 OWD(4)*1/3; OWD(3)*5/12 OWD(4)*2/3;OWD(3)*7/12 OWD(4)*2/3;OWD(3)*7/12 OWD(4)*1/3]);
        DrawFormattedText(OW, 'Incorrect!', 'center', 'center', settings.layout.redcolor); % set text
        trialseq(it,id.pres) = trialseq(it,id.pres) + 1;
        failtrials.errortrials = [failtrials.errortrials it];
        failtrials.errorRT = trialseq(it,id.RT);
    end
else % miss
    Screen('FillPoly',OW,[0 0 0],[OWD(3)*5/12 OWD(4)*1/3; OWD(3)*5/12 OWD(4)*2/3;OWD(3)*7/12 OWD(4)*2/3;OWD(3)*7/12 OWD(4)*1/3]);
    DrawFormattedText(OW, 'Too slow!', 'center', 'center', settings.layout.redcolor); % set text
    trialseq(it,id.pres) = trialseq(it,id.pres) + 1;
    failtrials.misstrials = [failtrials.misstrials it];
end

% display reward    
Screen('Flip', OW); % flip empty
WaitSecs(settings.duration.reward);
