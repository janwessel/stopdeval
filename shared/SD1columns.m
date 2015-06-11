function id = SD1columns(verbose)

% arguments
if nargin < 1; verbose = 0; end

if verbose == 1
    
    id.magn = 1; disp('magn = 1: raw reward magnitude');
    id.symb = 2; disp('symb = 2; symbol (1 = lowest reward, no stop, 2 = low reward, no stop etc.)');
    id.mags = 3; disp('mags = 3; stepwise reward magnitude (1-4)');
    id.stop = 4; disp('stop = 4; symbol associated with stop signal');
    id.syml = 5; disp('syml = 5; symbol layout (1 of 8)');
    id.symc = 6; disp('symc = 6; symbol color (1 of 8)');
    id.qdrn = 7; disp('qdrn = 7; quadrant (1 nw, 2 ne, 3 se, 4 sw, 5left half, 6right half)');
    id.resp = 8; disp('resp = 8; response (1 nw, 2 ne, 3 se, 4 sw, 5left half, 6right half)');
    id.RT = 9; disp('RT = 9; Reaction Time');
    id.bloc = 10; disp('bloc = 10; block');
    disp('Learning phase specific:');
    id.pres = 11; disp('pres = 11; number of presentations (errors and misses will be replayed)');
    disp('Learning phase specific:');
    id.ssig = 12; disp('ssig = 12; stop signal on trial?');
    id.lSSD = 13; disp('lSSD = 13; left SSD');
    id.rSSD = 14; disp('rSSD = 14; left SSD');
    id.accu = 15; disp('accu = 15; accuracy');
    disp('Betting phase specific:');
    id.bpic = 16; disp('bpic = 16; bet (amount) chosen');
    id.blev = 17; disp('blev = 17; bet (level) chosen');
    id.bopt = 18; disp('bopt = 18:18+levels-1; possible bets (in order on screen)');

else % non verbose

    id.magn = 1;
    id.symb = 2;
    id.mags = 3;
    id.stop = 4;
    id.syml = 5;
    id.symc = 6;
    id.qdrn = 7;
    id.resp = 8;
    id.RT = 9;
    id.bloc = 10;
    id.pres = 11;
    id.ssig = 12;
    id.lSSD = 13;
    id.rSSD = 14;
    id.accu = 15;
    id.bpic = 16;
    id.blev = 17;
    id.bopt = 18;
    
end
