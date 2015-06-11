function settings = SD1initialize(data,settings)

% reset random number generator
rng(sum(100*clock),'twister');

% symbols (will be changed by learning phase and then reloaded from file)
if data.phase == 1
    settings.symbols.layout = 1:length(settings.learning.magnitudes)*2;
    settings.symbols.colors = 1:length(settings.learning.magnitudes)*2;
end
settings.phase = data.phase;

% stimlayout
settings.layout.introsize = 40;
settings.layout.pointsize = 80;
settings.layout.fixcolor = [150 150 150];
settings.layout.redcolor = [255 0 0];
settings.layout.colors = [...
    0 1 0; ... % green
    0 0 1; ... % blue
    0 1 1; ... % cyan
    1 0 1; ... % magenta
    1 1 0; ... % yellow
    1 .5 0; ... % orange
    1 1 1; ... % white
    .5 .5 .5; ... % grey
    ];
settings.layout.colors = settings.layout.colors * 255;

% screen
if IsLinux; PsychGPUControl('FullScreenWindowDisablesCompositor', 1); end % fancy GNOME correction
screens = Screen('Screens');
[settings.screen.ow, settings.screen.owd] = Screen('Openwindow',max(screens), 0); % make screen, black bg
settings.LU = settings.screen.owd(3)/75; % lengthunits
Priority(MaxPriority(settings.screen.ow)); % prioritize

% initialize ptb calls
KbCheck; WaitSecs(.1); GetSecs;
ListenChar(2); HideCursor; % hide cursor and don't read kb

% prepare fonts
Screen('TextSize',settings.screen.ow,settings.layout.introsize);
Screen('TextFont',settings.screen.ow,'Arial'); % arial
Screen('TextStyle', settings.screen.ow, 0); % make normal

% commands
settings.commands.fix = [...
    'Screen(' char(39) 'DrawLine' char(39) ',' num2str(settings.screen.ow) ',[' num2str(settings.layout.fixcolor) '],' num2str(settings.screen.owd(3)*1/6) ',' num2str(settings.screen.owd(4)*1/2) ',' num2str(settings.screen.owd(3)*5/6) ',' num2str(settings.screen.owd(4)*1/2) ',2);' ...
    'Screen(' char(39) 'DrawLine' char(39) ',' num2str(settings.screen.ow) ',[' num2str(settings.layout.fixcolor) '],' num2str(settings.screen.owd(3)*1/2) ',' num2str(settings.screen.owd(4)*1/6) ',' num2str(settings.screen.owd(3)*1/2) ',' num2str(settings.screen.owd(4)*5/6) ',2);' ...
    ];
settings.commands.stopfix = [...
    'Screen(' char(39) 'DrawLine' char(39) ',' num2str(settings.screen.ow) ',[' num2str(settings.layout.fixcolor) '],' num2str(settings.screen.owd(3)*1/2) ',' num2str(settings.screen.owd(4)*1/6) ',' num2str(settings.screen.owd(3)*1/2) ',' num2str(settings.screen.owd(4)*5/6) ',2);' ...
    ];
settings.commands.betfix = [...
    'DrawFormattedText(' num2str(settings.screen.ow) ',' char(39) '+' char(39) ',' char(39) 'center' char(39) ',' char(39) 'center' char(39) ',[' num2str(settings.layout.fixcolor) ']);'... % set text
    ];

% stopsignal
InitializePsychSound(1); % prioritize audio
PsychPortAudio('Close'); % close all prior open ports
aduration = .1; % Signal duration (s)
freq = 900; % Signal Frequency
srate = 44100; % Sampling Frequency
wavdata = sin(2* pi * freq * [0:1/srate:aduration]); % make sine wave
audiohandle = PsychPortAudio('Open', [], [], 0, srate, 1);
PsychPortAudio('FillBuffer', audiohandle, wavdata); % pre buffer
settings.commands.stop = ['PsychPortAudio(' char(39) 'Start' char(39) ', ' num2str(audiohandle) ', 1, 0, 1);'];

% intro
SD1intro(settings);
