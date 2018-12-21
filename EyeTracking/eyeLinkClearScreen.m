function eyeLinkClearScreen(color)
% ----------------------------------------------------------------------
% eyeLinkClearScreen(color)
% ----------------------------------------------------------------------
% Goal of the function :
% Clear screen on the eyelink display.
% ----------------------------------------------------------------------
% Input(s) :
% color : color of the background (1 to 15)
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 23 / 09 / 2010
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------

Eyelink('command','clear_screen %d',color);

end