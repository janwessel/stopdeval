%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SD1 >> Stopping-induced devaluation experiment for Psychtoolbox 3.0.6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Jan R. Wessel, October 2011
%   Email:  jan.r.wessel@gmail.com
%   Web:    www.wessellab.org
%
%   Programmed on MATLAB 2012a, Psychtoolbox 3.0.6
%       Newer MATLAB should be supported, but check RNG reset command
%       [SD1initialize.m line 4]
%   I have explicitly tested this code under:
%       MAC OS X Mountain Lion running Matlab 2012a
%       Ubuntu 14.04. LTS running Matlab 2014b
%
%   When using this code, please cite the following two papers:
%       1. Wessel JR, O'Doherty JP, Berkebile M, Linderman D, Aron AR (2014).
%           Stimulus devaluation caused by stopping action.
%           Journal of Experimental Psychology: General 143(6):2316-29 
%       2. Wessel JR, Tonnesen A, Aron AR (in prep).
%           Stimulus devaluation induced by action stopping is greater for explicit value representations
%   #1 introduces the experiment, #2 shares the code.
%
%   Feel free to modify this code, but please only share the original routines.
%
%   Version History:
%       6/2015: Release version 1.0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SD1

    % INITIATE
    clear; clc;
    % directories
    infolder = fileparts(which('SD1.m'));
    outfolder = fullfile(infolder,'out');
    addpath(genpath(infolder));

    % FauxGUI
    disp('Welcome to SD1 by Jan R. Wessel');
    menuopen = true; data = []; settings = [];
    while menuopen;
        [option_sel,data,settings] = actualmenu(outfolder,data,settings);
        if option_sel > 3; menuopen = false; end
    end
    
end

%% MENU
function [option_sel,data,settings] = actualmenu(outfolder,data,settings);

    % menu
    menu_options = { ...
        'Initialize'; ...
        'Practice (Exp 1)'; ...
        'Practice (Exp 2)'; ...
        'Experiment 1'; ...
        'Experiment 2'; ...
        'Experiment 3'; ...
        'Close' ...
        };
    option_sel = menu('SD1 by JRW', menu_options);
    if isempty(option_sel) || option_sel == 0; option_sel = 7; end
    selected = lower(menu_options{option_sel});

    % SWITCH OPTIONS
    switch selected

        case 'initialize'
            % get information
            data = SD1data;
            % define settings
            settings = SD1settings;
            % save
            outfile = ['SD1_S' num2str(data.Nr) '_' date '_settings.mat'];
            save(fullfile(outfolder,outfile),'data','settings');
        case 'practice (exp 1)'
            % check for data, settings
            if isempty(data) || isempty(settings)
                [filn,filp] = uigetfile(fullfile(outfolder,'*.mat'),'Open settings file...'); load(fullfile(filp,filn));
            end
            % initialize
            data.phase = 1; settings.training = 1;
            % settings
            settings = SD1initialize(data,settings);
            % run
            trialseq = SD1p1(settings);
        case 'practice (exp 2)'
            % check for data, settings
            if isempty(data) || isempty(settings)
                [filn,filp] = uigetfile(fullfile(outfolder,'*.mat'),'Open settings file...'); load(fullfile(filp,filn));
            end
            % initialize
            data.phase = 2; settings.training = 1;
            % settings
            settings = SD1initialize(data,settings);
            % run
            trialseq = SD1p2(settings);
        case 'experiment 1'
            % check for data, settings
            if isempty(data) || isempty(settings)
                [filn,filp] = uigetfile(fullfile(outfolder,'*.mat'),'Open settings file...'); load(fullfile(filp,filn));
            end
            % initialize
            data.phase = 1; settings.training = 0;
            % settings
            settings = SD1initialize(data,settings);
            % run
            [trialseq_p1,settings,failtrials] = SD1p1(settings);
            % save
            outfile = ['SD1_S' num2str(data.Nr) '_' date '_p1.mat'];
            save(fullfile(outfolder,outfile),'trialseq_p1','data','settings');
        case 'experiment 2'
            % check for data, settings
            if isempty(data) || isempty(settings)
                [filn,filp] = uigetfile(fullfile(outfolder,'*_p1.mat'),'Open settings file...'); load(fullfile(filp,filn));
            end
            % initialize
            data.phase = 2; settings.training = 0;
            % settings
            settings = SD1initialize(data,settings);
            % run
            trialseq_p2 = SD1p2(settings);
            % save
            outfile = ['SD1_S' num2str(data.Nr) '_' date '_p2.mat'];
            save(fullfile(outfolder,outfile),'trialseq_p1','trialseq_p2','data','settings');
        case 'experiment 3'
            % check for data, settings
            if isempty(data) || isempty(settings)
                [filn,filp] = uigetfile(fullfile(outfolder,'*_p2.mat'),'Open settings file...'); load(fullfile(filp,filn));
            end
            % initialize
            data.phase = 3; settings.training = 0;
            % settings
            settings = SD1initialize(data,settings);
            % run
            [trialseq_p3,settings] = SD1p3(settings);
            % analyze
            output.p1 = SD1analyze_p1(trialseq_p1);
            output.p2 = SD1analyze_p2(trialseq_p2);
            output.p3 = SD1analyze_p3(trialseq_p3);
            % save
            outfile = ['SD1_S' num2str(data.Nr) '_' date '.mat'];
            save(fullfile(outfolder,outfile),'trialseq_p1','trialseq_p2','trialseq_p3','data','settings','output');
            % get rid of files
            delete(fullfile(outfolder,['SD1_S' num2str(data.Nr) '_' date '_p1.mat']));
            delete(fullfile(outfolder,['SD1_S' num2str(data.Nr) '_' date '_p2.mat']));
            delete(fullfile(outfolder,['SD1_S' num2str(data.Nr) '_' date '_settings.mat']));
        case 'close'
            disp('SD1: Closing...');
    end

    % HOUSEKEEPING
    if ~strcmpi(selected,'close') && ~strcmpi(selected,'initialize')
        SD1outro(settings,outfolder,data);
    end
    
end
