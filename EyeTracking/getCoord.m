function [x,y,t]=getCoord(wPtr,const)
% ----------------------------------------------------------------------
% [x,y,t]=getCoord(wPtr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Get gaze coordinates or mouse's in dummy mode.
% ----------------------------------------------------------------------
% Input(s) :
% wPtr = window pointer
% const = struct containing  const.TEST and const.DOMEYE;
% ----------------------------------------------------------------------
% Output(s):
% x : X eye/mouse coordinate (horizontal)
% y : Y eye/mouse coordinate (vertical)
% t : machine time
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 12 / 01 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

if const.TEST
    [x,y]=GetMouse(wPtr.main); % gaze position simulate by mouse position
    t = GetSecs;
else
    evt = Eyelink('newestfloatsample');
    x = evt.gx(const.recEye);
    y = evt.gy(const.recEye);
    t = evt.time;
    if evt.gx(const.recEye) == -32768 || evt.gy(const.recEye) == -32768
        x = 0;
        y = 0;
    end
end
end