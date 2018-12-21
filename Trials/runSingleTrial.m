function [resMat,vid,expDes,eyeCrit]=runSingleTrial(scr,aud,const,expDes,my_key,t,vid)
% ----------------------------------------------------------------------
% [resMat,vid,expDes,eyeCrit]=runSingleTrial(scr,aud,const,expDes,my_key,t,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Main file of the experiment, interaction between eye-tracker and
% display. Draw each sequence and return results.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% aud : sound configurations
% const : struct containing all the constant configurations.
% expDes : struct containing all the variable design configurations.
% my_key : keyboard keys names.
% t : experimental meter
% vid : structure of the video if demo mode activated
% ----------------------------------------------------------------------
% Output(s):
% resMat = experimental results
% resMat(1) = angle of reported test (1 = CW;   2 = CCW; -2 = NONE)
% resMat(2) = correctness of answer (1 = COR; 0 = INCOR; -2 = NONE)
% resMat(3) = fixation check (1 = SAC/FIX COR; 0 = SAC/FIX INCO -1 = FIX BREAK)
% vid = structure of the video if demo mode activated
% expDes = struct containing all the variable design configurations.
% eyeCrit(1) = saccade get out fixation boundary
% eyeCrit(2) = saccade latency too short
% eyeCrit(3) = saccade latency too long
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 04 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

while KbCheck; end
FlushEvents('KeyDown');
radBef = const.boundRadBef;

%% Compute and simplify var and rand :
if const.checkTrial
    fprintf(1,'\n\n\t========================  TRIAL %3.0f ========================\n',t);
end

% Rand 1 : Test position
rand1 = expDes.expMat(t,3);
if const.checkTrial;fprintf(1,'\n\tTest position = \t\t%i deg',const.stimAngleDeg(rand1));end

% Rand 2 : 1st saccade target
rand2       = expDes.expMat(t,4);
fixPos      = const.fixPos;
st1Angle    = const.stimAngleDeg(rand2);
if const.checkTrial;fprintf(1,'\n\t1st saccade target = \t\t%i deg',st1Angle);end

% Rand 3 : 2nd saccade target
rand3       = expDes.expMat(t,5);
st2Angle    = const.stimAngleDeg(rand3);
if const.checkTrial;fprintf(1,'\n\t2nd saccade target = \t\t%i deg',st2Angle);end

% Rand 4 : Saccade type
rand4 = expDes.expMat(t,6);
if const.checkTrial
    txt = {'Global effect sac. (+-30 deg)','Normal sac. (+-90 deg)'};
    fprintf(1,'\n\tSaccade type = \t\t\t%s',txt{rand4});
end

% Rand 5 : Initial fixation duration
rand5 = expDes.expMat(t,7);
fixDur = const.durIniFixJitter(rand5);
fixNum = const.numIniFixJitter(rand5);
if const.checkTrial;fprintf(1,'\n\tInitial fixation duration = \t300 ms + %3.0f ms / %i frm.',fixDur*1000,fixNum);end

% Rand 6 : ST/Cue to Test_offset duration
rand6 = expDes.expMat(t,8);
stTestOffDur = const.durST_Test(rand6);
stTestOffNum = const.numST_Test(rand6);

if const.checkTrial;fprintf(1,'\n\tSTs to test_offset duration = \t%3.0f ms / %i frm.',stTestOffDur*1000,stTestOffNum);end

% Rand 7 : Test presence 
rand7 = expDes.expMat(t,9);
if const.checkTrial;
    txt = {'present','absent'};
    fprintf(1,'\n\tTest =\t\t\t\t%s',txt{rand7});
end

% Rand 8 : Test tilt direction 
rand8 = expDes.expMat(t,10);
switch rand8
    case 1; signTilt = +1;
    case 2; signTilt = -1;
end
angVal = expDes.expMat(t,12)*signTilt;
if const.checkTrial;
    if rand7 == 2
        % nothing
    else
        fprintf(1,'\n\tTest tilt = \t\t\t%1.2f deg\n',angVal);
    end
end

% Rand 9
rand9 = expDes.expMat(t,11);
if const.checkTrial;
    txt = {'transient','permanent'};
    fprintf(1,'\n\tCueing =\t\t\t\t%s',txt{rand9});
end

%% Time

% FT
num_FT          = const.numIniFix+fixNum;
num_FT_start    = 1;
num_FT_end      = num_FT_start + num_FT - 1;

% ST/CUE
if rand9 == 1
    num_ST_start    = num_FT_end + 1;
    num_ST_end      = num_ST_start + const.numSTtransient - 1;
elseif rand9 == 2
    num_ST_start    = num_FT_end + 1;
    num_ST_end      = num_ST_start + const.numSTpermanent - 1;
end

% Test
num_Test       = const.numTest;
num_Test_start = num_ST_start + stTestOffNum - num_Test;
num_Test_end   = num_Test_start + num_Test - 1;

num_framesMax  = num_ST_start + const.numST_TrialEnd;

if const.checkTimeFrm
    fprintf(1,'\n\tFT: \t\t\t\t%i to %i',num_FT_start,num_FT_end);
    fprintf(1,'\n\tST: \t\t\t\t%i to %i',num_ST_start,num_ST_end);
    fprintf(1,'\n\tTest: \t\t\t\t%i to %i\n',num_Test_start,num_Test_end);
end


% list of position played
listPosNum = [1:size(const.stimMat,1)]';

for tPos = 1:size(listPosNum,1)
    % column 1 = position number
    % column 2 = distractor ?
    if listPosNum(tPos,1) ~= rand1
        listPosNum(tPos,2) = 1;
    else
        listPosNum(tPos,2) = 0;
    end
    
    % column 3 = test?
    if listPosNum(tPos,1) == rand1
        listPosNum(tPos,3) =1;
    else
        listPosNum(tPos,3) =0;
    end
    
end

% Prepare stimuli
% Stream
timeGabNoise     = zeros(1,num_framesMax);
timeRefreshPhase = zeros(1,num_framesMax);
timeRefreshMask  = zeros(1,num_framesMax);
timeGabNoise(num_Test_start:num_Test_end) = 1;

% here determine the gabor stream as not having the mask at the time of the test
numGab = 0;
for tBefTest = num_Test_start-1:-1:1
    numGab = numGab + 1;
    
    if numGab > 0
        timeGabNoise(tBefTest) = 0; % noise
    else
        timeGabNoise(tBefTest) = 1; % distractor gabors
    end
    
    % refresh gab phase
    if numGab == 0
        timeRefreshPhase(tBefTest) = 1;
    else
        timeRefreshPhase(tBefTest) = 0;
    end
    
    % refresh noise
    if numGab == const.numTest
        timeRefreshMask(tBefTest) = 1;
    else
        timeRefreshMask(tBefTest) = 0;
    end
    
    if numGab == const.numTest
        numGab = -const.numTest;
    end
end

% here determine the noise stream after the test
numGab = 0;
for tAftTest = num_Test_end+1:num_framesMax
    numGab = numGab + 1;
    
    if numGab > 0
        timeGabNoise(tAftTest) = 0; % noise
    else
        timeGabNoise(tAftTest) = 2; % blank
    end
    
    if numGab == 1 
        timeRefreshMask(tAftTest) = 1;
    else
        timeRefreshMask(tAftTest) = 0;
    end
    
    if numGab == const.numTest
        numGab = -const.numTest;
    end
    
end

% Appertures for gabors
apertureGabor = GenerateGaussian(const.gaborDiamX, const.gaborDiamY, const.gaborSigma, const.gaborSigma, 0, 0, 0);
apertureGabor = apertureGabor.*255;

% Appertures for noise
apertureNoise = GenerateGaussian(round(const.gaborDiamX/const.noisePixSize), round(const.gaborDiamY/const.noisePixSize), const.gaborSigma/const.noisePixSize, const.gaborSigma/const.noisePixSize, 0, 0, 0);
apertureNoise = apertureNoise.*255;

% Grating full contrast
phase   = rand;
grating = GenerateGrating(const.gaborDiamX, const.gaborDiamY, const.angleDistractor, const.gaborPixPerPeriod, phase, const.gaborContrast);
grating = grating + const.bgluminance;
grating(grating>1)=1;grating(grating<0)=0;
grating = grating.*255;

% Grating zero contrast
grating0 = GenerateGrating(const.gaborDiamX, const.gaborDiamY, const.angleDistractor, const.gaborPixPerPeriod, 0, 0);
grating0 = grating0 + const.bgluminance;
grating0(grating0>1)=1;grating0(grating0<0)=0;
grating0 = grating0.*255;

% Compute first noise
noiseImg = round((rand(round(const.gaborDiamX/const.noisePixSize), round(const.gaborDiamY/const.noisePixSize)))*scr.white);

% Make a mask
mask(:,:,1) = noiseImg; mask(:,:,2) = noiseImg; mask(:,:,3) = noiseImg;mask(:,:,4) = apertureNoise;

% Make a blank stucture
blank(:,:,1) = grating0;blank(:,:,2) = grating0;
blank(:,:,3) = grating0;blank(:,:,4) = apertureGabor;

% Make distractor/test gabor
gabDistTest(:,:,1) = grating;gabDistTest(:,:,2) = grating;
gabDistTest(:,:,3) = grating;gabDistTest(:,:,4) = apertureGabor;

% Make textures
texBlank    = Screen('MakeTexture',scr.main,blank);         % blank

%% Main loop
boundary.saccadeStart    = 0;
boundary.sac1            = 0;
boundary.latencyTooLong  = 0;
boundary.latencyTooShort = 0;
eyeCrit                  = [-2,-2,-2];
num_SacOn                = 0;
if const.eyeMvt && ~const.TEST
    Eyelink('message','EVENT_TRIAL_START');
end

nbf = 0;GetSecs;
while nbf < num_framesMax
    
    nbf = nbf + 1;
    Screen('FillRect',scr.main,const.colBG)
    
    %% Eye data coordinates
    if const.eyeMvt
        [x,y] = getCoord(scr,const);
    end
    
    %% Eye position check
    if const.eyeMvt
        % Before ST onset
        % Gaze is in circle boundary around FP
        if nbf >= 1 && nbf <= num_FT_end
            if sqrt((x-fixPos(1))^2+(y-fixPos(2))^2)>radBef
                if ~const.TEST
                    Eyelink('message','FIX_BREAK_START');
                end
                resMat = [-2,-2,-1];
                return
            end
        % After ST onset
        elseif nbf >= num_ST_start && nbf <= num_framesMax
            
            % Gaze quits boundary arround FP
            if sqrt((x-fixPos(1))^2+(y-fixPos(2))^2)>radBef
                boundary.saccadeStart = 1;
                if ~boundary.sac1
                    if ~const.TEST
                        Eyelink('message','EVENT_ONLINE_SACONSET_BOUND');
                    end
                    num_SacOn = nbf;
                    boundary.sac1 =1;
                end
            end
        end
    end
    
    %% Fixation target
    % Black & gray dots
    if nbf >= num_FT_start && nbf <= num_FT_end
        my_circle(scr.main,const.colTarDot,const.fixPos(1),const.fixPos(2),const.fixRad);
        my_circle(scr.main,const.colFix,const.fixPos(1),const.fixPos(2),const.fixCtrRad);
        my_circle(scr.main,const.colTarCtrCtrDot,const.fixPos(1),const.fixPos(2),const.fixCtrCtrRad);
    end
    
    %% Saccade target and other circles
    if nbf >= num_ST_start && nbf <= num_ST_end
       Screen('DrawDots',scr.main, const.stimMat([rand2 rand3],2:3)', const.frameDiamX , const.colST,[], 2);
       Screen('DrawDots',scr.main, const.stimMat([rand2 rand3],2:3)', const.frameDiamX - const.frameWidthX, const.colBG,[], 2);
    end
  
    %% Gabor/noise stream patches
    if nbf >= num_Test_start && nbf <= num_Test_end;
        if rand7 == 1
            drawTest = 1;
        else
            drawTest = 0;
        end
    else
        drawTest = 0;
    end

    if nbf <= num_Test_end;
        drawDistTest = 1;
    else
        drawDistTest = 0;
    end
    
    % Change noise every step of the noise stream
    if timeRefreshMask(nbf)
        noiseImg=round((rand(round(const.gaborDiamX/const.noisePixSize), round(const.gaborDiamY/const.noisePixSize)))*scr.white);
        
        % Make a mask
        mask(:,:,1) = noiseImg; mask(:,:,2) = noiseImg; mask(:,:,3) = noiseImg;mask(:,:,4) = apertureNoise; 
    end

    % Change phase every step of the stim stream
    if timeRefreshPhase(nbf)
        phase = rand;
        grating = GenerateGrating(const.gaborDiamX, const.gaborDiamY, const.angleDistractor, const.gaborPixPerPeriod, phase, const.gaborContrast);
        grating = grating + const.bgluminance;
        grating(grating>1)=1;grating(grating<0)=0;
        grating = grating.*255;
        
        % Make distractor/test gabor
        gabDistTest(:,:,1) = grating;gabDistTest(:,:,2) = grating;
        gabDistTest(:,:,3) = grating;gabDistTest(:,:,4) = apertureGabor;       
    end
    
    % Make textures
    texGabDistTest      = Screen('MakeTexture',scr.main,gabDistTest);       % distractor/test gabor
    texMask             = Screen('MakeTexture',scr.main,mask);              % mask
    
    % All positions to draw
    rotAngleAll  = [];
    texPtrAll    = [];
    destRectAll  = [];
    
    for tPos = 1:size(listPosNum,1)
        destRect = const.stimMat(tPos,4:7);
 
        % distractor stream alone
        if listPosNum(tPos,2) == 1
            if timeGabNoise(nbf)            % draw distractor or blank
                rotAngle = 0;
                if drawDistTest; texPtr = texGabDistTest;else texPtr = texBlank;end 
            elseif ~timeGabNoise(nbf)       % draw noise
                rotAngle = 0;
                texPtr = texMask;
            end
        
        % test stream alone
        elseif listPosNum(tPos,3) == 1
            if timeGabNoise(nbf)
                if ~drawTest                % draw distractor
                    rotAngle = 0;
                    if drawDistTest;texPtr = texGabDistTest;else texPtr = texBlank;end 
                elseif drawTest            % draw probe
                    rotAngle = angVal;
                    if drawDistTest;texPtr = texGabDistTest;else texPtr = texBlank;end 
                end
            elseif ~timeGabNoise(nbf)       % draw noise
                rotAngle = 0;
                texPtr = texMask;
            end
        end
        rotAngleAll = [rotAngleAll,rotAngle];
        texPtrAll   = [texPtrAll,texPtr];
        destRectAll = [destRectAll,destRect'];
    end
    
    % Draw all textures
    Screen('DrawTextures', scr.main, texPtrAll, [], destRectAll,rotAngleAll);

    % Close opened textures
    Screen('Close',texGabDistTest);
    Screen('Close',texMask);
   
    %% Eyelink messages
    if const.eyeMvt && ~const.TEST
        if nbf == num_FT_start;   Eyelink('message','FT_START');end
        if nbf == num_FT_end+1;   Eyelink('message','FT_END');end
        if nbf == num_ST_start;   Eyelink('message','ST_CUE_START');end
        if nbf == num_Test_start; Eyelink('message','TEST_START');end
        if nbf == num_Test_end+1; Eyelink('message','TEST_END');end
    end

    %% BIG Flip
    Screen('Flip',scr.main);   
    if const.pausetrial
        if nbf == num_Test_start  || nbf == num_FT_start || nbf == num_ST_start
            fprintf('\n\tnbf = %i ',nbf);KbWait(-1);while KbCheck(-1); end
        end
    end
    
    if const.mkVideo
        vid.j = vid.j + 1;
        if vid.j <= vid.sparseFile*1
            vid.j1 = vid.j1 + 1;
            vid.imageArray1(:,:,:,vid.j1)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*1 && vid.j <= vid.sparseFile*2
            vid.j2 = vid.j2 + 1;
            vid.imageArray2(:,:,:,vid.j2)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*2 && vid.j <= vid.sparseFile*3
            vid.j3 = vid.j3 + 1;
            vid.imageArray3(:,:,:,vid.j3)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*3 && vid.j <= vid.sparseFile*4
            vid.j4 = vid.j4 + 1;
            vid.imageArray4(:,:,:,vid.j4)=Screen('GetImage', scr.main);    
        elseif vid.j > vid.sparseFile*4 && vid.j <= vid.sparseFile*5
            vid.j5 = vid.j5 + 1;
            vid.imageArray5(:,:,:,vid.j5)=Screen('GetImage', scr.main);
        end
    else
        vid = [];
    end
    
end
Screen('Close',texBlank);

% Check saccade latency
sacLat_online = num_SacOn - num_ST_start;
if (sacLat_online >= const.num_maxLatency) && const.checkLat
    boundary.latencyTooLong = 1;
end
if (sacLat_online <= const.num_minLatency) && const.checkLat
    boundary.latencyTooShort = 1;
end

% Get answer
[key_press,~,vid]=getAnswer(scr,const,expDes,my_key,vid,boundary);

if const.eyeMvt && ~const.TEST
    Eyelink('message','EVENT_ANSWER');
end

if const.eyeMvt && ~const.TEST
    Eyelink('message','EVENT_ANSWER');
end

if const.eyeMvt
    if boundary.saccadeStart && ~boundary.latencyTooShort && ~boundary.latencyTooLong;
        eyeOK = 1;
    else
        eyeOK = 0;
    end
else
    eyeOK = 1;
end
eyeCrit = [boundary.saccadeStart,boundary.latencyTooShort,boundary.latencyTooLong];

% Check correctness of the response
if rand8 == 1 % Tilt right
    if key_press.rightArrow;
        resMat = [1,1,eyeOK];
    elseif key_press.leftArrow
        resMat = [2,0,eyeOK];
    elseif key_press.escape == 1
        resMat = [-2,-2,eyeOK];
        overDone(aud,const,vid);
    end
elseif rand8 == 2 % left
    if key_press.rightArrow;
        resMat = [1,0,eyeOK];
    elseif key_press.leftArrow
        resMat = [2,1,eyeOK];
    elseif key_press.escape == 1
        resMat = [-2,-2,eyeOK];
        overDone(aud,const,vid);
    end
end

% Feedback sound
if resMat(2) == 1;
    if const.eyeMvt && ~const.TEST;Eyelink('message','EVENT_ANSWER_CORRECT');end
elseif resMat(2) == 0;
    if const.eyeMvt && ~const.TEST;Eyelink('message','EVENT_ANSWER_INCORRECT');end
    my_sound(1,aud);
end

end