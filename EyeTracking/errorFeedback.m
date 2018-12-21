function errorFeedback(wPtr,str,expDes,t)
% ----------------------------------------------------------------------
% errorFeedback(wPtr,str,expDes,t)
% ----------------------------------------------------------------------
% Goal of the function :
% If fixation break, make a sound and display a message where to fixate.
% ----------------------------------------------------------------------
% Input(s) :
% wPtr : window pointer
% str : string message                            ex : fixer !
% expDes : struct containing all variable configurations.
% t : experimental meter
% ----------------------------------------------------------------------
% Output(s):
% none
%----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 09 / 07 / 2009
% Project : CompAtt
% Version : 11.0
% ----------------------------------------------------------------------
Snd('Play',[repmat(0.3,1,150) linspace(0.5,0.0,50)].*[zeros(1,100) sin(1:100)],4000);
FlushEvents;
bounds = Screen(wPtr.main,'TextBounds',str);

fixX = expDes.expMat(t,[]);fixY = expDes.expMat(t,[]);

x = fixX-bounds(3)/2;
y = fixY-bounds(4)/2;
Screen(wPtr.main,'Drawtext',str,x,y,wPtr.black);
Screen(wPtr.main,'Flip');
WaitSecs(0.3);
end