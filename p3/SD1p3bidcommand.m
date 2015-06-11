function SD1p3bidcommand(settings,trial,selected)

% initialize
id = SD1columns;

% arguments
if nargin < 3; selected = 0; end

% make shorter
OW = settings.screen.ow;
OD = settings.screen.owd;
COL = settings.layout.colors;
pSIZ = settings.layout.pointsize/2;
bSIZ = settings.layout.introsize/2;

% vertical positions
betpos = OD(4)/2 + settings.LU*2;
buttonpos = betpos + pSIZ + 10;

% colors
buttoncol = settings.layout.fixcolor;
betcol = repmat([255 255 255],settings.betting.stepsize,1); % white
if selected > 0; betcol(selected,:) = settings.layout.redcolor; end % color selected red

% get slots
slots = OD(3) * [1:settings.betting.stepsize]/(settings.betting.stepsize+7);
slots = slots-mean(slots); % center
slots = slots+OD(3)/2 - settings.LU;

% make buttons
if nargin < 3
    Screen('TextSize',OW,bSIZ);
    for is = 1:settings.betting.stepsize
        DrawFormattedText(OW, KbName(settings.buttons.bets(is)), slots(is) + pSIZ/2, buttonpos, buttoncol); % set text
    end
end
% make bids
Screen('TextSize',OW,pSIZ);
for is = 1:settings.betting.stepsize
    if trial(id.bopt-1+is) < 10
        DrawFormattedText(OW, num2str(trial(id.bopt-1+is)), slots(is)+pSIZ/2, betpos, betcol(is,:)); % set text
    else DrawFormattedText(OW, num2str(trial(id.bopt-1+is)), slots(is), betpos, betcol(is,:)); % set text
    end
end
