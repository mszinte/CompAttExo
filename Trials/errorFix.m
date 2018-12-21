function errorFix(scr,const,my_key)
% ----------------------------------------------------------------------
% errorFix(scr,const,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Blank stimuli and display three red circle around the fixation
% target to invite subject to refixate.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% const : struct containing all the constant configurations.
% my_key : struct containing all keyborad buttons.
% ----------------------------------------------------------------------
% Output(s):
% none
%----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 04 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

if const.eyeMvt && ~const.TEST
    Eyelink('message','EVENT_ERROR_FIX');
end

key_press.push_button = 0;

for nbf = 1:const.errorFixNbFrmMax
    Screen('FillRect',scr.main,const.colBG)
      
    if nbf >= const.errFixCircle1frmStart && nbf <= const.errFixCircle1frmEnd
        my_circle(scr.main,const.colErrFix,const.fixPos(1),const.fixPos(2),const.errfixOutRad1);
        my_circle(scr.main,const.colBG,const.fixPos(1),const.fixPos(2),const.errfixInRad1);
        
    elseif nbf >= const.errFixCircle2frmStart && nbf <= const.errFixCircle2frmEnd        
        my_circle(scr.main,const.colErrFix,const.fixPos(1),const.fixPos(2),const.errfixOutRad2);
        my_circle(scr.main,const.colBG,const.fixPos(1),const.fixPos(2),const.errfixInRad2);

    elseif nbf >= const.errFixCircle3frmStart && nbf <= const.errFixCircle3frmEnd
        my_circle(scr.main,const.colErrFix,const.fixPos(1),const.fixPos(2),const.errfixOutRad3);
        my_circle(scr.main,const.colBG,const.fixPos(1),const.fixPos(2),const.errfixInRad3);
    end
    
    % Fixation point and saccade target
    my_circle(scr.main,const.colTarDot,const.fixPos(1),const.fixPos(2),const.fixRad);
    
    % dot color = background color
    my_circle(scr.main,const.colFix,const.fixPos(1),const.fixPos(2),const.fixCtrRad);
    my_circle(scr.main,const.colTarCtrCtrDot,const.fixPos(1),const.fixPos(2),const.fixCtrCtrRad);
    
    Screen('Flip',scr.main);
    
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if ~key_press.push_button
            if (keyCode(my_key.escape)) && ~const.expStart
                sca
            end
        end
    end
end

end
    