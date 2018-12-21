function instructions(wPtr,const,my_key,text,button)
% ----------------------------------------------------------------------
% instructions(wPtr,const,my_key,text,button)
% ----------------------------------------------------------------------
% Goal of the function :
% Display instructions write in a specified matrix.
% ----------------------------------------------------------------------
% Input(s) :
% wPtr : main window pointer.
% const : struct containing all the constant configurations.
% text : library of the type {}.
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 29 / 10 / 2015
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------

while KbCheck; end 
KbName('UnifyKeyNames');

push_button = 0;
while ~push_button;
    
    FlushEvents ;
    [ keyIsDown, seconds, keyCode ] = KbCheck(-1);
    
    if ~isfield(const,'text_size')
        const.text_size = 25;    
        const.my_font = 'Arial';
    end
    if ~isfield(const,'colBG')
        const.colBG = 127;
        const.orange = [255,150,0];
        wPtr.white = 255;
        wPtr.black = 0;
        wPtr.gray = 127;
    end
    
    Screen('Preference', 'TextAntiAliasing',1);
    Screen('TextSize',wPtr.main, const.text_size);
    Screen ('TextFont', wPtr.main, const.my_font);
    Screen('FillRect', wPtr.main, const.colBG);
    
    sizeT = size(text);
    sizeB = size(button);
    lines = sizeT(1)+sizeB(1)+2;
    bound = Screen('TextBounds',wPtr.main,button{1,:});
    espace = ((const.text_size)*1.50);
    first_line = wPtr.y_mid - ((round(lines/2))*espace);
    
    addi = 0;
    for t_lines = 1:sizeT(1)
        Screen('DrawText',wPtr.main,text{t_lines,:},wPtr.x_mid-bound(3)/2,first_line+addi*espace, wPtr.white);
        addi = addi+1;
    end
    addi = addi+2;
    for b_lines = 1:sizeB(1)
        Screen('DrawText',wPtr.main,button{b_lines,:},wPtr.x_mid-bound(3)/2,first_line+addi*espace, const.orange);
    end
    Screen('Flip',wPtr.main);

    if keyIsDown
        if keyCode(my_key.space)
            push_button=1;
        elseif keyCode(my_key.escape) && ~const.expStart
            overDone(const);
        end
    end
end