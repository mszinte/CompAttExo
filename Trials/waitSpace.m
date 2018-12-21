function waitSpace(scr,const,my_key)
% ----------------------------------------------------------------------
% waitSpace(scr,const,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Wait at the beggining of the experiment and after each break that the
% participant press the space bar while fixating to start the trial.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% const : struct containing all the constant configurations.
% expDes : experimental design
% my_key : keyboard keys names.
% t : trial number
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 04 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

while KbCheck(-1); end
FlushEvents('KeyDown');

% Button flag
key_press.space         = 0;
key_press.escape        = 0;
key_press.push_button   = 0;

% Keyboard checking :
if const.eyeMvt && ~const.TEST
    Eyelink('message','EVENT_PRESS_SPACE');
end

while ~key_press.push_button
    Screen('FillRect',scr.main,const.colBG);

    % Black & gray dots
    my_circle(scr.main,const.colTarDot,const.fixPos(1),const.fixPos(2),const.fixRad);
    
    % Bulleye
    my_circle(scr.main,const.colWaitSpace,const.fixPos(1),const.fixPos(2),const.fixCtrRad);
    my_circle(scr.main,const.colTarCtrCtrDot,const.fixPos(1),const.fixPos(2),const.fixCtrCtrRad);
    
    Screen('Flip',scr.main);
     
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if ~key_press.push_button
            if (keyCode(my_key.escape)) && ~const.expStart
                sca
            elseif (keyCode(my_key.space))
                key_press.space = 1;
                key_press.push_button = 1;
            end
        end
    end
end

end