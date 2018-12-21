function [aud]=audioConfig(const)
% ----------------------------------------------------------------------
% [aud]=audioConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Give all information about the audio setup.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing subject information and saving files.
% ----------------------------------------------------------------------
% Output(s):
% aud : struct containing all audio configuration.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 04 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

% Master
aud.master_mode             = 1+8;      % mode of operation (1+8 = ????)
aud.master_reqlatclass      = 1;        % try to get the lowest latency
aud.master_rate             = 48000;    % master rate in samples per second (Hz);
aud.master_nChannels        = 2;        % number of audio channels to use (2 = stereo)

aud.master_rep              = 0;        % repetition of the sound data
aud.master_when             = 0;        % time the device should start
aud.master_waitforstart     = 1;        % wait until device has really started
aud.master_globalVol        = 0.05;     % volume 

% Slaves
aud.slaveStim_mode          = 1;        % mode of operation (1 = sound playback only)
aud.slave_rep               = 1;        % repetitions
aud.slave_when              = 0;        % time the device should start
aud.slave_waitforstart      = 0;        % wait until device has really started

aud.activeChannels          = [1;2];

InitializePsychSound(1);                % Initialize Sounddriver:

% typical beep config
aud.rampDur             = 0.005;
aud.ramp_sampleLenght   = 1;
aud.rampOffOn           = makeOffOnRamp(aud.rampDur,aud.ramp_sampleLenght,aud.master_rate);
aud.rampOnOff           = makeOnOffRamp(aud.rampDur,aud.ramp_sampleLenght,aud.master_rate);

%% Saving procedure :
% .mat file
save(const.aud_fileMat,'aud');

end