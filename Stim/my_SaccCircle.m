function my_SaccCircle(wPtr,vaDeg2pix, scr, const)
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
% Function created by Michael PUNTIROLI (michael.puntiroli@unige.ch)
% Last edit : 29 / 10 / 2015
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------

    % prepare circle coordinates
    left = scr.x_mid-const.fixRadValBig*vaDeg2pix(1); 
    top = scr.y_mid-const.fixRadValBig*vaDeg2pix(2);
    right = scr.x_mid+const.fixRadValBig*vaDeg2pix(1);
    bott = scr.y_mid+const.fixRadValBig*vaDeg2pix(2);
    Oval_XY = [left; top; right; bott]; %
    
    leftS = scr.x_mid-const.fixRadValFiller*vaDeg2pix(1); 
    topS = scr.y_mid-const.fixRadValFiller*vaDeg2pix(2);
    rightS = scr.x_mid+const.fixRadValFiller*vaDeg2pix(1);
    bottS = scr.y_mid+const.fixRadValFiller*vaDeg2pix(2);
    OvalS_XY = [leftS; topS; rightS; bottS];
    
    Screen('FrameOval', wPtr, const.colST, Oval_XY, []) % Large Circle
    Screen('FillOval', wPtr, const.colBG , OvalS_XY, []) % Filler Circle   
       
end