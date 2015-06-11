function SD1intro(settings)

% shorten
OW = settings.screen.ow;
OWD = settings.screen.owd;
FC =  settings.layout.fixcolor;

% Intro
Screen('TextSize',OW,settings.layout.introsize);
DrawFormattedText(OW, 'Press any key to start!', 'center', 'center',FC); % set text
Screen('Flip', OW); % update screen
WaitSecs(.5); KbWait(-1);

% Count in
DrawFormattedText(OW, 'Ready in 3...', 'center', 'center',FC); % set text
Screen('Flip', OW); % update screen
WaitSecs(1);
DrawFormattedText(OW, 'Ready in 2...', 'center', 'center',FC); % set text
Screen('Flip', OW); % update screen
WaitSecs(1);
DrawFormattedText(OW, 'Ready in 1...', 'center', 'center',FC); % set text
Screen('Flip', OW); % Ready screen
WaitSecs(1);
