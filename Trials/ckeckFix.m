function [cor,vid]=ckeckFix(scr,const,my_key,vid)
% ----------------------------------------------------------------------
% [cor,vid]=ckeckFix(scr,const,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a the fixation target (Green dot with bull-eye), and wait gaze 
% fixation. If gaze fixated then fixation target change his bull-eye
% color and wait 200ms until return a signal (cor) to start the trial.
% Modified for fixation experiment.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% const : struct containing varions constant.
% my_key : keyborad keys names
% vid : stucture for the demo video mode
% ----------------------------------------------------------------------
% Output(s):
% cor = flag or signal of a right fixation of FP.
% vid : stucture for the demo video mode
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 04 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

%% Compute and simplify var names :
timeout = const.timeOut;     % maximum fixation check time
tCorMin = const.tCorMin;     % minimum correct fixation time

%% Eye movement config
radBef = const.boundRadBef;

%% Eye data coordinates
if const.eyeMvt && ~const.TEST
    Eyelink('message', 'EVENT_FixationCheck');
end

if const.eyeMvt;
    tstart   = GetSecs;
    cor      = 0;
    corStart = 0;
    tCor     = 0;
    t        = tstart;

    while KbCheck(-1); end

    while ((t-tstart)<timeout && tCor<= tCorMin)
        
        Screen('FillRect',scr.main,const.colBG)
        
        [x,y]=getCoord(scr,const);
        
        % Fixation point and saccade target
        my_circle(scr.main,const.colTarDot,const.fixPos(1),const.fixPos(2),const.fixRad);
        
        % dot color = BackGround color
        my_circle(scr.main,const.colTarCtrDot,const.fixPos(1),const.fixPos(2),const.fixCtrRad);
        my_circle(scr.main,const.colTarCtrCtrDot,const.fixPos(1),const.fixPos(2),const.fixCtrCtrRad);
        
        if sqrt((x-const.fixPos(1))^2+(y-const.fixPos(2))^2) < radBef
            cor = 1;
            my_circle(scr.main,const.colTarCtrDot,const.fixPos(1),const.fixPos(2),const.fixCtrRad);
            my_circle(scr.main,const.colTarCtrCtrDot,const.fixPos(1),const.fixPos(2),const.fixCtrCtrRad);
            Screen(scr.main,'Flip');
        else
            cor = 0;
            Screen(scr.main,'Flip');
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
        end
        
        if cor == 1 && corStart == 0
            tCorStart = GetSecs;
            corStart = 1;
        elseif cor == 1 && corStart == 1
            tCor = GetSecs-tCorStart;
        else
            corStart = 0;
        end
        t = GetSecs;

        [keyIsDown, ~, keyCode] = KbCheck(-1);
        if keyIsDown
            if keyCode(my_key.escape) && ~const.expStart
                sca
            end
        end
    end
else 
    cor = 1;
end

end