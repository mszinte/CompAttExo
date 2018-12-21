function drawTrialInfoEL(scr,const,expDes,t)
% ----------------------------------------------------------------------
% drawTrialInfoEL(scr,const,expDes,t)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a box on the eyelink display.
% Modified for the fixation task
% ----------------------------------------------------------------------
% Input(s) :
% scr = window pointer
% const = struct containing constant configurations
% expDes = struct containing experiment design
% t : trial meter
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 04 / 05 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

% o--------------------------------------------------------------------o
% | EL Color index                                                     |
% o---------------------------------o----------------------------------o
% | Nb |  Other(cross,box,line)     | Clear screen                     |
% o---------------------------------o----------------------------------o
% |  0 | black                      | black                            |
% o---------------------------------o----------------------------------o
% |  1 | dark blue                  | dark dark blue                   |
% o----o----------------------------o----------------------------------o
% |  2 | dark green                 | dark blue                        |
% o----o----------------------------o----------------------------------o
% |  3 | dark turquoise             | blue                             |
% o----o----------------------------o----------------------------------o
% |  4 | dark red                   | light blue                       |
% o----o----------------------------o----------------------------------o
% |  5 | dark purple                | light light blue                 |
% o----o----------------------------o----------------------------------o
% |  6 | dark yellow (brown)        | turquoise                        |
% o----o----------------------------o----------------------------------o
% |  7 | light gray                 | light turquoise                  | 
% o----o----------------------------o----------------------------------o
% |  8 | dark gray                  | flashy blue                      |
% o----o----------------------------o----------------------------------o
% |  9 | light purple               | green                            |
% o----o----------------------------o----------------------------------o
% | 10 | light green                | dark dark green                  |
% o----o----------------------------o----------------------------------o
% | 11 | light turquoise            | dark green                       |
% o----o----------------------------o----------------------------------o
% | 12 | light red (orange)         | green                            |
% o----o----------------------------o----------------------------------o
% | 13 | pink                       | light green                      |
% o----o----------------------------o----------------------------------o
% | 14 | light yellow               | light green                      |
% o----o----------------------------o----------------------------------o
% | 15 | white                      | flashy green                     |
% o----o----------------------------o----------------------------------o

% Color config
stimFrmCol      = 15;
stCol           = 10;
distCol         = 4;
boundaryCol     = 15;
textCol         = 15;
BGcol           = 0;
dotCol          = 1;

% clear screen
eyeLinkClearScreen(BGcol)

% Rand 1 : Test position                        % /!\
rand1 = expDes.expMat(t,3);                     % /!\

% Rand 2 : 1st saccade target                   % /!\
rand2  = expDes.expMat(t,4);                     % /!\
fixPos = const.fixPos;

% Rand 3 : 2nd saccade target                   % /!\
rand3 = expDes.expMat(t,5);                     % /!\

% Rand 7 : Test presence                        % /!\
rand7 = expDes.expMat(t,9);                     % /!\

% Rand 8 : Test tilt direction 
rand8 = expDes.expMat(t,10);                    % /!\

switch rand8
    case 1; signTilt = +1;
    case 2; signTilt = -1;
end
angVal = expDes.expMat(t,12)*signTilt;

% list of position played
listPosNum = [1:size(const.stimMat,1)]';        % /!\

for tPos = 1:size(listPosNum,1)
    % column 1 = position number
    % column 2 = distractor?
    if listPosNum(tPos,1) ~= rand1              % /!\
        listPosNum(tPos,2) = 1;
    else
        listPosNum(tPos,2) = 0;
    end
    
    % column 3 = test?
    if listPosNum(tPos,1) == rand1;             % /!\
        listPosNum(tPos,3) =1;
    else
        listPosNum(tPos,3) =0;
    end
    
    % column 4 = cue?                           
    if listPosNum(tPos,1) == rand2 || listPosNum(tPos,1) == rand3       % /!\
        listPosNum(tPos,4) =1;
    else
        listPosNum(tPos,4) =0;
    end  
end

const.stimMat(:,1) = const.stimAngleDeg';                                       % angle
const.stimMat(:,2) = (cosd(const.stimAngleDeg) * const.radStim) + scr.x_mid;    % center x
const.stimMat(:,3) = (-sind(const.stimAngleDeg) * const.radStim) + scr.y_mid; 	% center y
const.stimMat(:,4) = const.stimMat(:,2) - const.gaborRadX;                      % rect left
const.stimMat(:,5) = const.stimMat(:,3) - const.gaborRadY;                      % rect top
const.stimMat(:,6) = const.stimMat(:,2) + const.gaborRadX;                      % rect right
const.stimMat(:,7) = const.stimMat(:,3) + const.gaborRadY;                      % rect bottom

%% Draw Stimulus
% All position + cue + probe
for stimNum = 1:size(listPosNum,1)
    rectCenterX = const.stimMat(stimNum,2);
    rectCenterY = const.stimMat(stimNum,3);
    
    if listPosNum(stimNum,4) == 1;
        colStim = stCol;
    else
        colStim = distCol;
    end
    
    % cue and not cue target
    eyeLinkDrawBox(rectCenterX,rectCenterY,const.gaborDiamX,const.gaborDiamY,3,stimFrmCol,colStim);
    
    % test target
    if listPosNum(stimNum,3) == 1
        addX = 15;addY = 0;
        if rand7 == 2
            % no probe to draw
        else
            eyeLinkDrawBox(rectCenterX+signTilt*addX,rectCenterY+signTilt*addY,10,10,2,stimFrmCol,dotCol);
        end
    end
end

% Fixation target & boundary
eyeLinkDrawBox(fixPos(1),fixPos(2),const.fixRad*2,const.fixRad*2,2,stimFrmCol,dotCol);
eyeLinkDrawBox(fixPos(1),fixPos(2),const.boundRadBef*2,const.boundRadBef*2,1,boundaryCol,1);
 
% Two lines of text during trial (slow process)
corT    = expDes.corTrial;
incorT  = expDes.incorTrial;
remT    = expDes.iniEndJ - expDes.corTrial;

text0 = sprintf('Test angle = %2.2f | tCor=%3.0f | tInc = %3.0f | tRem=%3.0f ',angVal,corT,incorT,remT);
eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 30,textCol,text0);

WaitSecs(0.1);
end