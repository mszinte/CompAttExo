function [const]=constConfig(scr,const)
% ----------------------------------------------------------------------
% [const]=constConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute all constant data of this experiment.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containg previous constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing all constant data.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 04 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

%% Text configuration :
const.my_font = 'Arial';
const.text_size = 20;

%% Time
% Probe duration
const.durTest = 0.025;              const.numTest = (round(const.durTest/scr.frame_duration));

% Fixation
const.durIniFix          = 0.300;   const.numIniFix = (round(const.durIniFix/scr.frame_duration));
const.durMaxIniFixJitter = 0.300;   const.numMaxIniFixJitter = (round(const.durMaxIniFixJitter/scr.frame_duration));
const.durMinIniFixJitter = 0;       const.numMinIniFixJitter = (round(const.durMinIniFixJitter/scr.frame_duration));
const.numIniFixJitter    = const.numMinIniFixJitter:1:const.numMaxIniFixJitter;
const.durIniFixJitter    = const.numIniFixJitter*scr.frame_duration;

% Saccade targets
const.durSTtransient = 0.050;       const.numSTtransient = (round(const.durSTtransient/scr.frame_duration));
const.durSTpermanent = 0.500;       const.numSTpermanent = (round(const.durSTpermanent/scr.frame_duration));

% ST to Test offset duration
const.durMinST_Test = +0.100;       const.numMinST_Test = (round(const.durMinST_Test/scr.frame_duration));
const.durMaxST_Test = +0.200;       const.numMaxST_Test = (round(const.durMaxST_Test/scr.frame_duration));

const.numST_Test = const.numMinST_Test:const.numMaxST_Test;
const.durST_Test = const.numST_Test*scr.frame_duration;

% ST onset to trial end
const.durST_TrialEnd = 0.500;       const.numST_TrialEnd = (round(const.durST_TrialEnd/scr.frame_duration));

% Frame max
const.durFrameMax = const.durIniFix + const.durMaxIniFixJitter + const.durST_TrialEnd;
const.nbFramesMax = const.numIniFix + const.numMaxIniFixJitter + const.numST_TrialEnd;

% Saccade in circle
const.durInBound = 0.050;           const.numInBound = (round(const.durInBound/scr.frame_duration));

% saccade latency
const.dur_maxLatency = 0.350;       const.num_maxLatency = (round(const.dur_maxLatency/scr.frame_duration));
const.dur_minLatency = 0.050;       const.num_minLatency = (round(const.dur_minLatency/scr.frame_duration));


%% Fixation & Saccade targets
const.fixRadVal       = 0.4;                                    [const.fixRad,~]              = vaDeg2pix(const.fixRadVal,scr);
const.fixCtrRadVal    = const.fixRadVal*3/4;                    [const.fixCtrRad,~]           = vaDeg2pix(const.fixCtrRadVal,scr);
const.fixCtrCtrRadVal = const.fixCtrRadVal*1/2;                 [const.fixCtrCtrRad,~]        = vaDeg2pix(const.fixCtrCtrRadVal,scr);

const.sacRadVal       = 1;                                      [const.sacRad,~]              = vaDeg2pix(const.sacRadVal,scr);
const.sacWidthVal     = const.fixRadVal - const.fixCtrRadVal;   [const.sacWidth,~]            = vaDeg2pix(const.sacWidthVal,scr);

const.sacAmpVal       = 10;                                     [const.sacAmpX,const.sacAmpY] = vaDeg2pix(const.sacAmpVal,scr);
const.fixPos          = [scr.x_mid,scr.y_mid];

%% Test locations
const.gaborRadVal       = 1.1;
[const.gaborRadX,const.gaborRadY] = vaDeg2pix(const.gaborRadVal,scr);
const.gaborDiamX        = const.gaborRadX * 2;
const.gaborDiamY        = const.gaborRadX * 2;
const.angleDistractor   = 0;
const.gaborFrequency    = 2.5;
[const.oneDeg2pix,~]    = vaDeg2pix(1,scr);
const.gaborPixPerPeriod = const.oneDeg2pix/const.gaborFrequency;
const.gaborContrast     = 1;
const.gabSigma_period   = 0.9;
const.gaborSigma        = const.gaborPixPerPeriod*const.gabSigma_period;
const.bgluminance       = const.colBG/255;
const.noisePixSize      = 5;

const.frameDiamX        = const.gaborDiamX;
const.frameWidthX       = (const.fixRad - const.fixCtrRad)*2;

% position
const.radStimVal        = 10;              [const.radStim,~] = vaDeg2pix(const.radStimVal ,scr);
const.stepAngle         = 15;
const.stimAngleStart    = 0;
const.stimAngleDeg      = const.stimAngleStart :const.stepAngle:(360-const.stepAngle+const.stimAngleStart);

const.stimMat(:,1)      = const.stimAngleDeg';                                       % angle
const.stimMat(:,2)      = (cosd(const.stimAngleDeg) * const.radStim) + scr.x_mid;    % center x
const.stimMat(:,3)      = (-sind(const.stimAngleDeg) * const.radStim) + scr.y_mid; 	 % center y
const.stimMat(:,4)      = const.stimMat(:,2) - const.gaborRadX;                      % rect left
const.stimMat(:,5)      = const.stimMat(:,3) - const.gaborRadY;                      % rect top
const.stimMat(:,6)      = const.stimMat(:,2) + const.gaborRadX;                      % rect right
const.stimMat(:,7)      = const.stimMat(:,3) + const.gaborRadY;                      % rect bottom

% threshold angle
const.angleThreshold    = 12;

%% Error fixation
const.durErrorFixGap1   = 0.150;         const.errorFixGap1NbFrm = (round(const.durErrorFixGap1/scr.frame_duration));
const.durErrorFixGap2   = 0.100;         const.errorFixGap2NbFrm = (round(const.durErrorFixGap2/scr.frame_duration));
const.durErrorFixCircle = 0.050;         const.errorFixCircleNbFrm = (round(const.durErrorFixCircle/scr.frame_duration));

const.durErrorFix   = const.durErrorFixGap1 + 3* const.durErrorFixCircle + 2*const.durErrorFixGap2;             
const.errorFixNbFrm = (round(const.durErrorFix/scr.frame_duration));

const.errorFixNbFrmMax = const.errorFixNbFrm;

const.errFixCircle1frmStart = 1 + const.errorFixGap1NbFrm;                              
const.errFixCircle1frmEnd   = const.errFixCircle1frmStart + const.errorFixCircleNbFrm -1;
const.errFixCircle2frmStart = const.errFixCircle1frmEnd + const.errorFixGap2NbFrm + 1;
const.errFixCircle2frmEnd   = const.errFixCircle2frmStart + const.errorFixCircleNbFrm -1;
const.errFixCircle3frmStart = const.errFixCircle2frmEnd + const.errorFixGap2NbFrm + 1;
const.errFixCircle3frmEnd   = const.errFixCircle3frmStart + const.errorFixCircleNbFrm -1;

const.errfixWidth   = 0.1;
const.errfixRadCtr1 = 2;
const.errfixRadCtr2 = 1.5;
const.errfixRadCtr3 = 1;

const.errfixOutRad1Val = const.errfixRadCtr1 + (const.errfixWidth/2); [const.errfixOutRad1,~] = vaDeg2pix(const.errfixOutRad1Val,scr); 
const.errfixInRad1Val  = const.errfixRadCtr1 - (const.errfixWidth/2); [const.errfixInRad1,~]  = vaDeg2pix(const.errfixInRad1Val,scr); 

const.errfixOutRad2Val = const.errfixRadCtr2 + (const.errfixWidth/2); [const.errfixOutRad2,~] = vaDeg2pix(const.errfixOutRad2Val,scr); 
const.errfixInRad2Val  = const.errfixRadCtr2 - (const.errfixWidth/2); [const.errfixInRad2,~]  = vaDeg2pix(const.errfixInRad2Val,scr); 

const.errfixOutRad3Val = const.errfixRadCtr3 + (const.errfixWidth/2); [const.errfixOutRad3,~] = vaDeg2pix(const.errfixOutRad3Val,scr); 
const.errfixInRad3Val  = const.errfixRadCtr3 - (const.errfixWidth/2); [const.errfixInRad3,~]  = vaDeg2pix(const.errfixInRad3Val,scr); 

%% General settings
% Time :
const.my_clock_ini = clock;

% Eye-tracker configuration :
const.boundRadBefVal = 2;           const.boundRadBef = vaDeg2pix(const.boundRadBefVal,scr);
const.boundRadAftVal = 3;           const.boundRadAft = vaDeg2pix(const.boundRadAftVal,scr);

const.calTargetRadVal   = 0.25;     [const.calTargetRad,~]   = vaDeg2pix(const.calTargetRadVal,scr);
const.calTargetWidthVal = 0.15;     [const.calTargetWidth,~] = vaDeg2pix(const.calTargetWidthVal*const.calTargetRadVal,scr);

const.timeOut = 1.5;
const.tCorMin = 0.200;

%% Saving procedure :
const_file = fopen(const.const_fileDat,'w');
fprintf(const_file,'Subject initial :\t%s\n',const.sjct_name);
if const.fromBlock == 1 
    fprintf(const_file,'Subject age :\t%i\n',const.sjct_age);
    fprintf(const_file,'Subject gender :\t%s\n',const.sjct_gender);
end
fprintf(const_file,'Recorded Eye :\t%s\n',const.sjct_DomEye);
fprintf(const_file,'Date : \t%i-%i-%i\n',const.my_clock_ini(3),const.my_clock_ini(2),const.my_clock_ini(1));
fprintf(const_file,'Starting time : \t%ih%i\n',const.my_clock_ini(4),const.my_clock_ini(5));
fprintf(const_file,'Fixation radius (deg):\t%i\n',const.boundRadBefVal);

fclose('all');

% .mat file
save(const.const_fileMat,'const');

end