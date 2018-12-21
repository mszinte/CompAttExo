function instructionsIm(scr,const,my_key,nameImage,exitFlag)
% ----------------------------------------------------------------------
% instructionsIm(scr,const,my_key,text,button,exitFlag)
% ----------------------------------------------------------------------
% Goal of the function :
% Display instructions draw in .tif file.
% ----------------------------------------------------------------------
% Input(s) :
% scr : main window pointer.
% const : struct containing all the constant configurations.
% nameImage : name of the file image to display
% exitFlag : if = 1 (quit after 5sec)
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

while KbCheck(-1); end
KbName('UnifyKeyNames');

dirImageFile = '../../../../Instructions/Image/';
dirImage = [dirImageFile,nameImage,'.tif'];
imageToDraw =  imread(dirImage);

t_handle = Screen('MakeTexture',scr.main,imageToDraw);
push_button = 0;

t0 = GetSecs;
tEnd = 5;

while ~push_button;
    
    FlushEvents ;
    Screen('FillRect',scr.main,scr.white);
    Screen('DrawTexture',scr.main,t_handle);
    t1 = Screen('Flip',scr.main);
    
    if exitFlag
        if t1 - t0 > tEnd;
            push_button=1;
        end
    end
        
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if keyCode(my_key.space)
            push_button=1;
        elseif keyCode(my_key.escape) && ~const.expStart
            sca
        end
    end
    
end