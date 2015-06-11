function SD1p3blockfeedback(settings,trialseq,it);

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

% get params
misstrials = blocktrials(blocktrials(:,id.pres) > 1,:);
if isempty(misstrials); misses = 0; else; misses = size(misstrials,1); end
gotrials = blocktrials(blocktrials(:,id.pres) == 1,:);
GoRT = round(mean(blocktrials(:,id.RT))*1000);

% make display
DrawFormattedText(OW, 'You can take a break now!', 'center', SIZ, [255 255 255]); % set text
DrawFormattedText(OW, 'Last block:', 'center', 2.5*SIZ, COL); % set text
DrawFormattedText(OW, ['Reaction time: ' num2str(GoRT)], 'center', 4*SIZ, COL); % set text
DrawFormattedText(OW, ['Too slow: ' num2str(misses)], 'center', 5.5*SIZ, COL); % set text
DrawFormattedText(OW, 'Press any key to continue...', 'center', OWD(4)-SIZ, COL); % set text

% flip
Screen('Flip', OW); % update screen
WaitSecs(.5); KbWait(-1);
