function my_sound(t,aud)
% ----------------------------------------------------------------------
% my_sound(t,aud)
% ----------------------------------------------------------------------
% Goal of the function :
% Play a wave file a specified number of time.
% ----------------------------------------------------------------------
% Input(s) :
% t => select prepare beep frequency and duration
% aud = sound configuration
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 12 / 01 / 2016
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------

if t == 1
    stimFreq = [4000;0;3000];
    stimDur  = [0.1;0.01;0.1];
elseif t == 2
    stimFreq = [3000];
    stimDur  = [0.10];
elseif t == 3
    stimFreq = [4000];
    stimDur  = [0.2];
elseif t == 4
    stimFreq = [7000;5000];
    stimDur  = [0.2;0.2];
elseif t == 5
    stimFreq = [5000];
    stimDur  = [0.2];
elseif t == 6
    stimFreq = [5000;5000;5000];
    stimDur  = [0.2;0.2;0.2];
elseif t == 7
    stimFreq = [5000];
    stimDur  = [0.2];
elseif t == 8
    stimFreq = [500;300];
    stimDur  = [0.15;0.2];
elseif t == 9
    stimFreq = [3000;2000;2000];
    stimDur  = [0.2;0.2;0.2];
elseif t == 10;
    stimFreq = [3000;4000;4000];
    stimDur  = [0.2;0.2;0.2];
elseif t == 11;
    stimFreq = [900;200];
    stimDur  = [0.2;0.2];
elseif t == 12;
    
end

stimNb = size(stimFreq,1);

% Compute ramped sound and modulator
stimAll = [];
rampAll = [];
for tStim = 1:stimNb
    for i = 1:aud.master_nChannels;
        stim(i,:) = MakeBeep(stimFreq(tStim), stimDur(tStim), aud.master_rate);
        ramp(i,:) = [aud.rampOffOn,ones(1,size(stim(i,:),2)-size(aud.rampOffOn,2)-size(aud.rampOnOff,2)),aud.rampOnOff];
    end
    stimAll = [stimAll,stim];stim =[];
    rampAll = [rampAll,ramp];ramp =[];
end

PsychPortAudio('FillBuffer' ,aud.stim_handle, stimAll.*rampAll);
PsychPortAudio('Start', aud.stim_handle, aud.slave_rep, aud.slave_when, aud.slave_waitforstart);

end
