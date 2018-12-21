function [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute an experimental randomised matrix containing all variable data
% used in the experiment.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing all constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg all variable data randomised.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 05 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

%% Experimental random variables

% Rand 1 : Test position [24 modalities]
% ========
expDes.oneR = [1:24]';
% 01 =   0 deg
% 02 =  15 deg
% 03 =  30 deg
% ...
% 23 = 330 deg
% 24 = 345 deg

% Rand 2 : 1st saccade target [24 modalities]
% ======
expDes.twoR =[1:24]';
% 01 =   0 deg
% 02 =  15 deg
% 03 =  30 deg
% ...
% 23 = 330 deg
% 24 = 345 deg

% Rand 3 : 2nd saccade target [24 modalities]
% =======
expDes.threeR =[1:24]';
% 01 =   0 deg
% 02 =  15 deg
% 03 =  30 deg
% ...
% 23 = 330 deg
% 24 = 345 deg

% Rand 4 : Saccade types (~angular distance) [2 modalities]
% =======
expDes.fourR =[1;2];
% 1 = global effect saccade - (30/330 deg)
% 2 = no global effect saccade - (90/270 deg)

% Rand 5 : Initial fixation duration jitter [37 modalities]
% ======
expDes.fiveR = [1:size(const.numIniFixJitter,2)]';
% 1  =   0 ms
% 2  =  ~8 ms
% ...
% 37 = 300 ms

% Rand 6 : STs-Test_offset duration [13 modalities]
% ======
expDes.sixR = 1:size(const.numST_Test,2);
% 1  = +100 ms
% 2  = +108 ms
% ...
% 13 = +200 ms 

% Rand 7 : Test presence [1/2 modalities]
% ======
expDes.sevenR = [ones(965,1);ones(35,1)*2];
% 1 = test present (96.5%)
% 2 = test absent (3.5%)

% Rand 8 : Test tilt direction [2 modalities]
% ======
expDes.eightR =[1;2];
% 1 = tilt cw
% 2 = tilt ccw

% Rand 9 : Cueing type [2 modalities]
expDes.nineR = [1;2];
% 1 = transient cue
% 2 = permanent cue

%% Experimental configuration :
expDes.nb_cond    = 0;
expDes.nb_var     = 0;
expDes.nb_rand    = 9;
expDes.nb_list    = 0;

expDes.nb_trials = 290; % 24 blocks of 290 trials each (~15 min each)

%      24 test positions
% x     2 saccade types (30 deg -global effect- vs. 90 deg -no global effect-)
%       2 cueing types (transient cueing vs. permanent cueing)
% x     1 time bins (+100/+200)
% x    70 repetitions
% +   240 no probe trials (60 repetitions x 2 saccade types x 2 cueing types) = ~3.5% of all trials (240/6960)
% =======================
% = 6960 trials (x 2 sec/trial ~ 4 h)

expDes.timeCalibMin = 30;
expDes.timeCalib    = expDes.timeCalibMin*60;

%% Experimental loop
rng('default');rng('shuffle');

blockT = const.fromBlock;
for t_trial = 1:expDes.nb_trials
    
    randVal1   = randperm(numel(expDes.oneR));    rand_rand1  = expDes.oneR(randVal1(1));
    randVal2   = randperm(numel(expDes.twoR));    rand_rand2  = expDes.twoR(randVal2(1));
    randVal3   = randperm(numel(expDes.threeR));  rand_rand3  = expDes.threeR(randVal3(1));
    randVal4   = randperm(numel(expDes.fourR));   rand_rand4  = expDes.fourR(randVal4(1));
    randVal5   = randperm(numel(expDes.fiveR));   rand_rand5  = expDes.fiveR(randVal5(1));
    randVal6   = randperm(numel(expDes.sixR));    rand_rand6  = expDes.sixR(randVal6(1));
    randVal7   = randperm(numel(expDes.sevenR));  rand_rand7  = expDes.sevenR(randVal7(1));
    randVal8   = randperm(numel(expDes.eightR));  rand_rand8  = expDes.eightR(randVal8(1));
    randVal9   = randperm(numel(expDes.nineR));   rand_rand9  = expDes.nineR(randVal9(1));
    
    %% redo the selection of saccade targets
    valCheck = abs(round(const.stimAngleDeg(rand_rand2) - const.stimAngleDeg(rand_rand3)));                 
    if rand_rand4 == 1                                                                                                          
        while valCheck ~= 30 && valCheck ~= 330
            randVal2   = randperm(numel(expDes.twoR));      rand_rand2  = expDes.twoR(randVal2(1));         
            randVal3   = randperm(numel(expDes.threeR));    rand_rand3  = expDes.threeR(randVal3(1));       
            valCheck = abs(round(const.stimAngleDeg(rand_rand2) - const.stimAngleDeg(rand_rand3)));         
        end
        
    elseif rand_rand4 == 2                                                                                 
        while valCheck ~= 90 && valCheck ~= 270
            randVal2   = randperm(numel(expDes.twoR));      rand_rand2  = expDes.twoR(randVal2(1));         
            randVal3   = randperm(numel(expDes.threeR));    rand_rand3  = expDes.threeR(randVal3(1));       
            valCheck = abs(round(const.stimAngleDeg(rand_rand2) - const.stimAngleDeg(rand_rand3)));         
        end
    end
    
    % angle value
    angleVal = const.angleThreshold;

    % Processing of other time and frameStuff
    expDes.expMat(t_trial,:) = [ blockT,         t_trial,        rand_rand1,     rand_rand2,     rand_rand3,...
                                 rand_rand4,     rand_rand5,     rand_rand6,     rand_rand7,     rand_rand8,...
                                 rand_rand9,     angleVal];
end

%% Saving procedure :
% .dat file
dsg_file = fopen(const.design_fileDat,'w');
fprintf(dsg_file,'Time between calibration (min):\t%i\n',expDes.timeCalibMin);
fprintf(dsg_file,'Nb of variables:\t\t%i\n',expDes.nb_var);
fprintf(dsg_file,'Nb of random var:\t\t%i\n',expDes.nb_rand);
fprintf(dsg_file,'Total nb of trials:\t\t%i\n',expDes.nb_trials);
fclose('all');

% .mat file
save(const.design_fileMat,'expDes');
