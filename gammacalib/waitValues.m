function [lineCalib] = waitValues(wPtr,const,colDisplay)
% ----------------------------------------------------------------------
% [returnVal] = waitValues(wPtr,const,colDisplay)
% ----------------------------------------------------------------------
% Goal of the function :
% Display values of the just measured and diplayed color, and wait for 
% entering measured values.
% ----------------------------------------------------------------------
% Input(s) :
% wPtr : window pointer struct
% const : structure containing all constant configurations
% colDisplay : values of the color displayed
% ----------------------------------------------------------------------
% Output(s):
% lineCalib : returned measured value and color displayed
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 12 / 08 / 2010
% Project : none
% Version : 1.0
% ----------------------------------------------------------------------

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

while KbCheck(-1); end
FlushEvents('KeyDown');
inputVal = '';
text_l1 = ('Displayed color :');
text_l2 = ('Measured Values :');
res_l1 = sprintf('[%i,%i,%i]',colDisplay(1),colDisplay(2),colDisplay(3));

text = {text_l1;text_l2};
espace = ((const.text_size)*1.50);
first_line = wPtr.y_mid - (1*espace);

Screen('FillRect',wPtr.main,wPtr.white)
Screen('Preference', 'TextAntiAliasing',1);
Screen('TextSize',wPtr.main, const.text_size);
Screen ('TextFont', wPtr.main, const.my_font);

press_enter = 0;
valPress = '';

while ~press_enter

    res_l2 = valPress;
    res = {res_l1;res_l2};

    addi = 0;
    for t_lines = 1:2
        Screen('DrawText',wPtr.main,text{t_lines,:},wPtr.x_mid-300,first_line+addi*espace, wPtr.black);
        Screen('DrawText',wPtr.main,res{t_lines,:}, wPtr.x_mid+200,first_line+addi*espace, wPtr.black);
        addi = addi+1;
    end
    if CharAvail
        char = GetChar(0,1);
        valPress = [valPress,char];
        switch char 
            case 10;    
                if isnan(str2double(valPress))
                    
                    valPress = valPress(1:end-1);
                else
                    
                    press_enter =1;
                end
            case 8;     if size(valPress,2)>1;valPress = valPress(1:end-2);end
        end
    end

    Screen('Flip',wPtr.main);
    
end
returnVal = str2double(valPress);
lineCalib = [colDisplay,returnVal];

end