function trialseq = SD1p2randomize(settings);

% initialize
id = SD1columns;

% intro
DrawFormattedText(settings.screen.ow, 'Making sequence, please wait!', 'center', 'center', settings.layout.fixcolor); % set text
Screen('Flip', settings.screen.ow);

% criteria
maxstop_inarow = 4;
maxgo_inarow = 10;
maxsame_inarow = 4;

% initial draw
trialseq = SD1p2sequence(settings);

if settings.training == 0

    % stop diagnostic
    diag_s = zeros(size(trialseq,1)-(maxstop_inarow-1),1);
    for it = 1:size(trialseq,1)-(maxstop_inarow-1); diag_s(it,1) = sum(trialseq(it:it+(maxstop_inarow-1),id.ssig)); end
    % go diagnostic
    diag_g = zeros(size(trialseq,1)-(maxgo_inarow-1),1);
    for it = 1:size(trialseq,1)-(maxgo_inarow-1); diag_g(it,1) = sum(trialseq(it:it+(maxgo_inarow-1),id.ssig)); end
    % same symbol in a row diagnostic
    diag_ss = zeros(size(trialseq,1)-(maxsame_inarow-1),1);
    for it = 1:size(trialseq,1)-(maxsame_inarow-1); diag_ss(it,1) = var(trialseq(it:it+(maxsame_inarow-1),id.symb)); end

    % loop
    while max(diag_s) == maxstop_inarow || min(diag_g) == 0 || min(diag_ss) == 0

        % initial draw
        trialseq = SD1p2sequence(settings);

        % stop diagnostic
        diag_s = zeros(size(trialseq,1)-(maxstop_inarow-1),1);
        for it = 1:size(trialseq,1)-(maxstop_inarow-1); diag_s(it,1) = sum(trialseq(it:it+(maxstop_inarow-1),id.ssig)); end
        % go diagnostic
        diag_g = zeros(size(trialseq,1)-(maxgo_inarow-1),1);
        for it = 1:size(trialseq,1)-(maxgo_inarow-1); diag_g(it,1) = sum(trialseq(it:it+(maxgo_inarow-1),id.ssig)); end
        % same symbol in a row diagnostic
        diag_ss = zeros(size(trialseq,1)-(maxsame_inarow-1),1);
        for it = 1:size(trialseq,1)-(maxsame_inarow-1); diag_ss(it,1) = var(trialseq(it:it+(maxsame_inarow-1),id.symb)); end

    end
    
end

% outro
DrawFormattedText(settings.screen.ow, 'Sequence done, press key to start!', 'center', 'center', settings.layout.fixcolor); % set text
Screen('Flip', settings.screen.ow);
KbWait(-1);
