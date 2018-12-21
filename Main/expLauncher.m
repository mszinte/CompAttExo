%% General experimenter launcher %%
%  =============================  %
% By :      Luca WOLLENBERG
% Project : Global effect and attention
% With :    Heiner DEUBEL & Martin SZINTE 
%  =============================  %

% First setups
clear all;clear mex;clear functions;close all;home;ListenChar(1);

% General settings
const.expName      = 'CompAtt';             % experiment name.
const.expStart     = 0;                     % Start of a recording exp                          0 = NO   , 1 = YES
const.mkVideo      = 0;                     % Make a video of one trial                         0 = NO   , 1 = YES
const.checkLat     = 1;                     % Saccade latency feedback                          0 = NO   , 1 = YES
const.checkTrial   = 0;                     % Print trial conditions                            0 = NO   , 1 = YES
const.checkTimeFrm = 0;                     % Print time frames                                 0 = NO   , 1 = YES
const.pausetrial   = 0;                     % Pauses trial for every new onset                  0 = NO   , 1 = YES              %/!\

% External controls
const.eyeMvt       = 0;                     % control eye movement,                             0 = NO, 1 = YES
const.TEST         = 0;                     % Dummy mode or not,                                0 = NO(eye) , 1 = YES (mouse)

% Screen
const.calibFlag    = 0;                     % Luminance gamma linearisation calibration         0 = NO, 1 = YES
const.calibType    = 2;                     % There is 2 types of gamma calibration             1 = Gray linearized, 2 = RGB linearized

const.desiredFD    = 60;                    % Desired refresh rate (used value = 120)
const.desiredRes   = [1440,900];            % Desired resolution (used value 1440, 640)

% Path
dir = (which('expLauncher'));cd(dir(1:end-18));

% Block definition
if ~const.expStart || const.mkVideo
    numBlockMain = 1;
    const.numBlockMainTot = 1;
else
    numBlockMain = 12;                   % ~1 h
    const.numBlockMainTot = 24;          % ~4 h
end

% Subject configuration
[const] = sbjConfig(const);

for block = const.fromBlock:(const.fromBlock+numBlockMain-1)
    const.fromBlock = block;
    main(const);clear expDes;
    if block  ~= const.numBlockMainTot;cd ../../../../;end
end

