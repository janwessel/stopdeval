function trialseq = SD1p2accuracy(settings,trialseq,it);

% initialize
id = SD1columns;

% access accuracy
if trialseq(it,id.ssig) == 1 % stop
    if trialseq(it,id.resp) > 0 % failed stop
        trialseq(it,id.accu) = 3;
        % update SSD
        trialseq(it+1:end,id.lSSD-1+trialseq(it,id.qdrn)-length(settings.learning.magnitudes)) = trialseq(it,id.lSSD-1+trialseq(it,id.qdrn)-length(settings.learning.magnitudes)) - settings.stopping.SSDincrement;
        if trialseq(it+1:end,id.lSSD-1+trialseq(it,id.qdrn)-length(settings.learning.magnitudes)) < 0
            trialseq(it+1:end,id.lSSD-1+trialseq(it,id.qdrn)-length(settings.learning.magnitudes)) = 0;
        end
    else % succesful stop
        trialseq(it,id.accu) = 4; 
        % update SSD
        trialseq(it+1:end,id.lSSD-1+trialseq(it,id.qdrn)-length(settings.learning.magnitudes)) = trialseq(it,id.lSSD-1+trialseq(it,id.qdrn)-length(settings.learning.magnitudes)) + settings.stopping.SSDincrement;
        if trialseq(it+1:end,id.lSSD-1+trialseq(it,id.qdrn)-length(settings.learning.magnitudes)) < 0
            trialseq(it+1:end,id.lSSD-1+trialseq(it,id.qdrn)-length(settings.learning.magnitudes)) = 0;
        end
    end
elseif trialseq(it,id.ssig) == 0 % go
    if trialseq(it,id.resp) == trialseq(it,id.qdrn) % correct
        trialseq(it,id.accu) = 1;
    elseif trialseq(it,id.resp) == 0 % miss
        trialseq(it,id.accu) = 5;
        % display            
        Screen('FillPoly',settings.screen.ow,[0 0 0],[settings.screen.owd(3)*5/12 settings.screen.owd(4)*1/3; settings.screen.owd(3)*5/12 settings.screen.owd(4)*2/3;settings.screen.owd(3)*7/12 settings.screen.owd(4)*2/3;settings.screen.owd(3)*7/12 settings.screen.owd(4)*1/3]);
        DrawFormattedText(settings.screen.ow, 'Too slow!', 'center', 'center', [255 0 0]); % set text 
    elseif trialseq(it,id.resp) ~= trialseq(it,id.qdrn) % error
        trialseq(it,id.accu) = 2;
    end
end
