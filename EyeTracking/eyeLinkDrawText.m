function eyeLinkDrawText(x,y,color,text)
% ----------------------------------------------------------------------
% eyeLinkDrawText(x,y,color,text)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw text on the eyelink display.
% ----------------------------------------------------------------------
% Input(s) :
% x : center X 
% y : center Y
% color : color of the text (1 to 15)
% text : string containing the text to display.
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 12 / 01 / 2016
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------

Eyelink('command','draw_text %d %d %d %s', round(x),round(y),color,text);

end