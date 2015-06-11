function SD1p1blockfeedback(settings,trialseq,it,failtrials);

% initialize
id = SD1columns;

% shorten
OW = settings.screen.ow;
OWD = settings.screen.owd;
COL = settings.layout.fixcolor;
SIZ = settings.layout.introsize;

% set textsize
Screen('TextSize',OW,SIZ);

% get blocktrials
block = trialseq(it,id.bloc);
blocktrials = trialseq(trialseq(:,id.bloc) == block,:);

% get RT
gotrials = blocktrials(blocktrials(:,id.pres) == 1,:);
GoRT = mean(gotrials(:,id.RT))*1000;

% errors and misses
if isempty(failtrials.errortrials); errors = 0; else; errors = length(failtrials.errortrials); end
if isempty(failtrials.misstrials); misses = 0; else; misses = length(failtrials.misstrials); end

% Display
DrawFormattedText(OW, 'You can take a break now!', 'center', SIZ, [255 255 255]); % set text
DrawFormattedText(OW, ['Last block (' num2str(trialseq(it,id.bloc)) '/' num2str(trialseq(end,id.bloc)) '):'], 'center', 2.5*SIZ, COL); % set text
DrawFormattedText(OW, ['Reaction time: ' num2str(round(GoRT))], 'center', 3.5*SIZ, COL); % set text
DrawFormattedText(OW, ['Errors (total): ' num2str(errors)], 'center', 4.5*SIZ, COL); % set text
DrawFormattedText(OW, ['Misses (total): ' num2str(misses)], 'center', 5.5*SIZ, COL); % set text
DrawFormattedText(OW, 'Press any key to continue...', 'center', OWD(4)-SIZ*2, COL); % set text
Screen('Flip', OW); % update screen
WaitSecs(.2); KbWait(-1);

% Count back in
if it < size(trialseq,1); SD1intro(settings); end
