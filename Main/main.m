function main(const)
% ----------------------------------------------------------------------
% main(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Launch all function of the experiment
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 05 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

% File director
[const] = dirSaveFile(const);

% Screen configuration :
[scr] = scrConfig(const);

% Keyboard configuration :
tic;[my_key] = keyConfig;

% Instruction file for screen calibration :
[textExp,button] = instructionConfig;

% Gamma calibration and color config :
if const.expStart;
    [scr]=gammaCalib(scr,const,my_key,textExp,button);
end

% Color config :
[scr,const] = constColor(scr,const);

% Experimental constant :
[const] = constConfig(scr,const);

% Experimental design configuration :
[expDes] = designConfig(const);

% Get video settings trial :
[expDes,vid] = getVideoSettings(scr,const,expDes);

% Auditory configurations
[aud] = audioConfig(const);

% Open screen window :
[scr.main,scr.rect] = Screen('OpenWindow',scr.scr_num,[0 0 0],[], scr.clr_depth,2);
Screen('BlendFunction', scr.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
priorityLevel = MaxPriority(scr.main);Priority(priorityLevel);

% Open sound pointer:
aud.master_main = PsychPortAudio('Open', [], aud.master_mode, aud.master_reqlatclass, aud.master_rate, aud.master_nChannels); % Open a PortAudio audio device and initialize it
PsychPortAudio('Start', aud.master_main, aud.master_rep, aud.master_when, aud.master_waitforstart); % Start a Port Audio device
PsychPortAudio('Volume', aud.master_main, aud.master_globalVol); % Set audio output volume
aud.stim_handle = PsychPortAudio('OpenSlave', aud.master_main, aud.slaveStim_mode);

% Initialise EyeLink :
if const.eyeMvt;[el,const] = initEyeLink(scr,const);
else el = [];end

% Main part :
ListenChar(2);GetSecs;
[vid]=runTrials(scr,aud,const,expDes,el,my_key,vid);

% End
overDone(aud,const,vid);

end