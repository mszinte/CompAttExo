function rect=EyelinkDrawCalTarget(el, x, y)
% ----------------------------------------------------------------------
% rect=EyelinkDrawCalTarget(el, x, y)
% ----------------------------------------------------------------------
% Goal of the function :
% Modification of the EyeLink toolbox to draw target for calibration
% adjusted by a specified values measure in constConfig and to draw dots
% with anti-aliasing.
% ----------------------------------------------------------------------
% Input(s) :
% wPtr : window pointer.
% const : struct containing many constant configuration.
% ----------------------------------------------------------------------
% Output(s):
% el : eye-link structure.
% error : disconnected link code. 
% const : struct containing edfFileName
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update :     08 / 10 / 2011
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------

rBig   = el.calibrationtargetsize;
rSmall = el.calibrationtargetwidth;

Screen('DrawDots',el.window, [round(x),round(y)],round(rBig*2), el.foregroundcolour , [],2);
Screen('DrawDots',el.window, [round(x),round(y)],round(rSmall*2), el.backgroundcolour, [],2);

Screen('Flip',el.window);

rect = round([x-rSmall, y-rSmall, x+rSmall, y+rSmall]);

end