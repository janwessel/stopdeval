% duration in ms
function [respkey,RT] = SD1response(settings,starttime,duration)            

respkey = 0; RT = 0; % preassign
DisableKeysForKbCheck('empty');

while (GetSecs - starttime) <= duration

    [keytoggle, endtime, keycode] = KbCheck;
    
    % this if loop gets response, otherwise keeps checking
    if keycode(settings.buttons.nw)==1
        respkey = 1;
        DisableKeysForKbCheck(find(keycode)); % disable key
        RT = endtime - starttime;
        break
    elseif keycode(settings.buttons.ne)==1
        respkey = 2;
        DisableKeysForKbCheck(find(keycode)); % disable key
        RT = endtime - starttime;
        break
    elseif keycode(settings.buttons.se)==1
        respkey = 3;
        DisableKeysForKbCheck(find(keycode)); % disable key
        RT = endtime - starttime;
        break
    elseif keycode(settings.buttons.sw)==1
        respkey = 4;
        DisableKeysForKbCheck(find(keycode)); % disable key
        RT = endtime - starttime;
        break
    elseif keycode(settings.buttons.left)==1
        respkey = 5;
        DisableKeysForKbCheck(find(keycode)); % disable key
        RT = endtime - starttime;
        break
    elseif keycode(settings.buttons.right)==1
        respkey = 6;
        DisableKeysForKbCheck(find(keycode)); % disable key
        RT = endtime - starttime;
        break
    elseif ~isempty(intersect(settings.buttons.bets,find(keycode)))
        respkey = find(settings.buttons.bets==find(keycode));
        RT = endtime - starttime;
        DisableKeysForKbCheck(find(keycode)); % disable key
        break
    end

    WaitSecs(0.001); % prevent overload
end
% convert keys in case only 4 keys are used (phase 2 only)
if settings.phase == 2 && strcmpi(settings.betting.type,'select')
    if respkey == 2 || respkey == 3; respkey = 6; end
    if respkey == 1 || respkey == 4; respkey = 5; end
end
