function [key_press,tRT,vid]=getAnswer(scr,const,expDes,my_key,vid,boundary)
% ----------------------------------------------------------------------
% [key_press,tRT,vid]=getAnswer(scr,const,expDes,my_key,vid,boundary)
% ----------------------------------------------------------------------
% Goal of the function :
% Check keyboard press, and return flags.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer.
% const : struct containing all the constant configurations.
% my_key : keyboard keys names.
% expDes : Design matrix.
% vid : video structure if demo mode activated
% boundary : saccade boundary
% ----------------------------------------------------------------------
% Output(s):
% key_press : struct containing key answer.
% tRT : reaction time
% vid : video structure if demo mode activated
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 04 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

% Button flag
key_press.rightArrow	= 0;
key_press.leftArrow     = 0;
key_press.escape        = 0;
key_press.push_button   = 0;

% Keyboard checking :
timeRep   = 0;
firstFlip = 0;

while ~key_press.push_button
    
    Screen('FillRect',scr.main,const.colBG);
    
    if const.checkLat
        if const.eyeMvt && (boundary.latencyTooLong || ~boundary.saccadeStart) && ~const.mkVideo
            Screen('TextSize',scr.main,15);
            bounds = Screen(scr.main,'TextBounds','GO FASTER!');
            xTxt = const.fixPos(1)-bounds(3)/2;
            yTxt = const.fixPos(2)-bounds(4)/2;
            Screen(scr.main,'Drawtext','GO FASTER!',xTxt,yTxt,const.colTarDot);
        
        % be careful, check that if things go wrong
        elseif const.eyeMvt && boundary.latencyTooShort && ~const.mkVideo
            Screen('TextSize',scr.main,15);
            bounds = Screen(scr.main,'TextBounds','DONT ANTICIPATE!');
            xTxt = const.fixPos(1)-bounds(3)/2;
            yTxt = const.fixPos(2)-bounds(4)/2;
            Screen(scr.main,'Drawtext','DONT ANTICIPATE!',xTxt,yTxt,const.colTarDot);
        end
    end
    Screen('Flip',scr.main);
    
    if const.eyeMvt && ~const.TEST && ~firstFlip
        firstFlip = 1;
        Eyelink('message','EVENT_GET_ANSWER');
    end
    
    if const.mkVideo
        vid.j = vid.j + 1;
        if vid.j <= vid.sparseFile*1
            vid.j1 = vid.j1 + 1;
            vid.imageArray1(:,:,:,vid.j1)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*1 && vid.j <= vid.sparseFile*2
            vid.j2 = vid.j2 + 1;
            vid.imageArray2(:,:,:,vid.j2)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*2 && vid.j <= vid.sparseFile*3
            vid.j3 = vid.j3 + 1;
            vid.imageArray3(:,:,:,vid.j3)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*3 && vid.j <= vid.sparseFile*4
            vid.j4 = vid.j4 + 1;
            vid.imageArray4(:,:,:,vid.j4)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*4 && vid.j <= vid.sparseFile*5
            vid.j5 = vid.j5 + 1;
            vid.imageArray5(:,:,:,vid.j5)=Screen('GetImage', scr.main);
        end
        timeRep = timeRep +1;
        if timeRep == expDes.timeRTvid;
            key_press.push_button = 1;
            tRT = GetSecs;
            key_press.rightArrow = 1;
        end
    end
    
    [keyIsDown, seconds, keyCode] = KbCheck(-1);
    if keyIsDown
        if ~key_press.push_button
            if (keyCode(my_key.escape)) && ~const.expStart
                key_press.push_button = 1;
                key_press.escape = 1;
                tRT = 0;
            elseif (keyCode(my_key.right))
                key_press.rightArrow = 1;
                key_press.push_button = 1;
                tRT = seconds;
            elseif (keyCode(my_key.left))
                key_press.leftArrow = 1;
                key_press.push_button = 1;
                tRT = seconds;
            end
        end
    end
end

end