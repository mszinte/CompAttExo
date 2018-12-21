function my_circle(wPtr,color,x,y,r)
% ----------------------------------------------------------------------
% my_circle(wPtr,color,x,y,r)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a circle or oval in position (x,y) with radius (r).
% ----------------------------------------------------------------------
% Input(s) :
% wPtr = Window Pointer                             ex : w
% color = color of the circle in RBG or RGBA        ex : color = [0 0 0]
% x = position x of the center                      ex : x = 550
% y = position y of the center                      ex : y = 330
% r = radius for X (in pixel)                       ex : r = 25
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last edit : 08 / 07 / 2009
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------

if r>30
    Screen('FillOval',wPtr,color,[(x-r) (y-r) (x+r) (y+r)]);
else
    Screen('DrawDots', wPtr,[x,y],r*2,color,[],2)
end
end