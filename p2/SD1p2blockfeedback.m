function SD1p2blockfeedback(settings,trialseq,it);

% initialize
id = SD1columns;

% shorten
OW = settings.screen.ow;
OWD = settings.screen.owd;
COL = settings.layout.fixcolor;
SIZ = settings.layout.introsize;

% set textsize
Screen('TextSize',OW,settings.layout.introsize);

% get blocktrials
block = trialseq(it,id.bloc);
blocktrials = trialseq(trialseq(:,id.bloc) == block,:);

% get params
gotrials = blocktrials(blocktrials(:,id.accu) == 1,:);
errortrials = blocktrials(blocktrials(:,id.accu) == 2,:);
misstrials = blocktrials(blocktrials(:,id.accu) == 5,:);
succtrials = blocktrials(blocktrials(:,id.accu) == 4,:);
failtrials = blocktrials(blocktrials(:,id.accu) == 3,:);
GoRT = mean(gotrials(:,id.RT))*1000;
errors = size(errortrials,1);
misses = size(misstrials,1);
stopsucc = 100*size(succtrials,1) / (size(succtrials,1) + size(failtrials,1));
stoptrials = [succtrials; failtrials];
% ssd
ssd = [];
for ist = 1:size(stoptrials,1)
    ssd(ist) = stoptrials(ist,id.ssig+stoptrials(ist,id.qdrn)-4);
end
meanSSD = mean(ssd);

% display
DrawFormattedText(OW, 'You can take a break now!', 'center', SIZ, [255 255 255]); % set text
DrawFormattedText(OW, ['Last block (' num2str(trialseq(it,id.bloc)) '/' num2str(trialseq(end,id.bloc)) '):'], 'center', 2.5*SIZ, COL); % set text
DrawFormattedText(OW, ['Reaction time: ' num2str(round(GoRT)) '.' num2str(round(stopsucc))], 'center', 3.5*SIZ, COL); % set text
DrawFormattedText(OW, ['Variability: ' num2str(meanSSD)], 'center', 4.5*SIZ, COL); % set text
DrawFormattedText(OW, ['Direction errors: ' num2str(errors)], 'center', 5.5*SIZ, COL); % set text
DrawFormattedText(OW, ['Misses (Too slow): ' num2str(misses)], 'center', 6.5*SIZ, COL); % set text
DrawFormattedText(OW, 'Press any key to continue...', 'center', OWD(4)-SIZ, COL); % set text

% update screen
Screen('Flip', OW); 
Screen('TextSize',OW,settings.layout.introsize);
WaitSecs(.5); KbWait(-1);
