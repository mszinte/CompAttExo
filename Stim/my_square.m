function my_square(wPtr,type,color,x,y,r,add,width)
% ----------------------------------------------------------------------
% my_square(wPtr,type,color,x,y,r,add,width)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a probe of different type in function of the ordrer
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
% Last edit : 09 / 11 / 2009
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------

if type == 'circle'
    if r>30
        Screen('FillOval',wPtr,color,[(x-r) (y-r) (x+r) (y+r)]);
    else
        Screen('DrawDots', wPtr,[x,y],r*2,color,[],2)
    end

elseif type =='square';
    
    Screen('FillRect', wPtr,color,[(x-r) (y-r) (x+r) (y+r)]);

elseif type == 'line--';    
    Screen('FillRect', wPtr,color,[(x-width/2) (y-r/2) (x+width/2) (y+r/2)]);
    
elseif type == 'line- ';
    Screen('FillRect', wPtr,color,[(x-width/2) (y-r/2-add) (x+width/2) (y+r/2+add)]);
    
end
    
end