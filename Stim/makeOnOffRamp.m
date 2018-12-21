function rampOffOn = makeOnOffRamp(rampDur,sampleLength,sampRate)
% ----------------------------------------------------------------------
% rampOffOn = makeOnOffRamp(rampDur,sampleLength,sampRate)
% ----------------------------------------------------------------------
% Goal of the function :
% Add on-off ramp to a sound
% ----------------------------------------------------------------------
% Input(s) :
% rampDur = ramp duration
% sampleLenght = il numero di bit che devono essere suonati
% sampRate = sample rate (Hz)
% ----------------------------------------------------------------------
% Output(s):
% rampOnOff = ramp from On to Off sound
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
%          from a code by David AAGTEN-MURPHY
% Last update : 22 / 11 / 2013
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------

rampMat= ones(1,sampleLength);
rampVals= 1:rampDur*sampRate;
onRamp= 0.5*cos([pi:pi/(length(rampVals)-1):2*pi])+0.5;
offRamp= 0.5*cos([0:pi/(length(rampVals)-1):pi])+0.5;
rampMat(1:length(onRamp))= onRamp;
rampMat(length(rampMat)-length(onRamp)+1:length(rampMat))=offRamp;

rampOffOn = (rampMat);

