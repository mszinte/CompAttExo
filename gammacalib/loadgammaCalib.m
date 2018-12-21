function loadgammaCalib(wPtr,const)
% ----------------------------------------------------------------------
% loadgammaCalib(wPtr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Measure/Find and load gamma correction for luminance
% ----------------------------------------------------------------------
% Input(s) :
% wPtr : window pointer struct
% const : struct containing all constant settings
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 13 / 01 / 2010
% Project : none
% Version : 1.0
% ----------------------------------------------------------------------
dirC = wPtr.dirCalib;
if const.calibType == 1
    wPtr.invGammaTable = csvread(sprintf('%s/Gamma/%s/%2.0f/GRAY_Lin/InvertGammaTable_%s_%2.0f.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist));
elseif const.calibType == 2
    wPtr.invGammaTable = csvread(sprintf('%s/Gamma/%s/%2.0f/RGB_Lin/InvertGammaTable_%s_%2.0f.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist));
end
Screen('LoadNormalizedGammaTable', wPtr.scr_num, wPtr.invGammaTable);
WaitSecs(1);
end