function [vid]=runTrials(scr,aud,const,expDes,el,my_key,vid)
% ----------------------------------------------------------------------
% [vid]=runTrials(scr,aud,const,expDes,el,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Main trial function, prepare eye-link, and display the trial function.
% Save the experimental data in different files.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% aud : sound configurations
% const : struct containing all the constant configurations.
% expDes : struct containing all the variable design and configurations.
% el : struct containing all eye-link configuration.
% my_key : keyborad keys names
% vid : video structure if demo mode activated
% ----------------------------------------------------------------------
% Output(s):
% vid : video structure if demo mode activated
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 04 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

%% Beginning
% First mouse config:
if const.eyeMvt && ~const.TEST;HideCursor;end

if const.eyeMvt && ~const.TEST
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'General intructions');
end

% instructions
instructionsIm(scr,const,my_key,'CompAtt',0);

% First calibration :
if const.eyeMvt && ~const.TEST
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'1st Calibration instruction');
    instructionsIm(scr,const,my_key,'Calibration',0);
    calibresult = EyelinkDoTrackerSetup(el);
    if calibresult==el.TERMINATE_KEY
        return
    end
end

%% Main Loop
expDone = 0;
newJ    = 0;
iniClockCalib = GetSecs;
startJ  = 1;
endJ    = size(expDes.expMat,1);
expDes.iniEndJ = endJ;

if const.mkVideo;endJ = 1;end

calibReq          = 0;
calibBreak        = 0;
expDes.corTrial   = 0;
expDes.incorTrial = 0;

while ~expDone
    for t = startJ:endJ
        trialDone = 0;
        while ~trialDone
            
            % Calib problems
            nowClockCalib = GetSecs;
            if (nowClockCalib - iniClockCalib)> expDes.timeCalib
                calibReq = 1;
            end
            
            if calibReq==1
                if const.eyeMvt && ~const.TEST
                    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Pause');
                    textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
                    eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
                    instructionsIm(scr,const,my_key,'Pause',0);
                    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Calibration Pause');
                    textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
                    eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
                    instructionsIm(scr,const,my_key,'Calibration',0);
                    EyelinkDoTrackerSetup(el);
                    iniClockCalib = GetSecs;
                    calibBreak = 1;
                end
                calibReq=0;
            end

            if const.eyeMvt && ~const.TEST
                Eyelink('command', 'record_status_message ''TRIAL %d''', t);
                Eyelink('message', 'TRIALID %d', t);
            end

            fix    = 0;
            record = 0;
            while fix ~= 1 || ~record
                if const.eyeMvt && ~const.TEST
                    if ~record
                        
                        Eyelink('startrecording');
                        key=1;
                        while key ~=  0
                            key = EyelinkGetKey(el);		% dump any pending local keys
                        end
                        error=Eyelink('checkrecording'); 	% check recording status
                        
                        if error==0
                            record = 1;
                            Eyelink('message', 'RECORD_START');
                        else
                            record = 0;
                            Eyelink('message', 'RECORD_FAILURE');
                        end
                    end
                else
                    record = 1;
                end
                
                if fix~=1 && record
                    if const.eyeMvt && ~const.TEST;
                        drawTrialInfoEL(scr,const,expDes,t);
                    end
                    if t ==1 || calibBreak == 1;
                        calibBreak = 0;
                        waitSpace(scr,const,my_key)
                    end
                    [fix,vid]=ckeckFix(scr,const,my_key,vid);
                end
                
                if fix~=1 && record
                    if ~const.TEST
                        eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Error calibration instruction');
                        textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
                        eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
                        instructionsIm(scr,const,my_key,'Calibration',0);
                        EyelinkDoTrackerSetup(el);
                        calibBreak = 1;
                    end
                    record = 0;
                end
            end
            
            % Trial beggining
            if const.eyeMvt && ~const.TEST
                Eyelink('message', 'TRIAL_START %d', t);
                Eyelink('message', 'SYNCTIME');
            end
            
            [resMat,vid,expDes,eyeCrit] = runSingleTrial(scr,aud,const,expDes,my_key,t,vid);
            if const.eyeMvt && ~const.TEST && resMat(3) ~= -1
                Eyelink('message', 'TRIAL_END %d',  t);
                Eyelink('stoprecording');
            end
                    
            % Trial meter
            if resMat(3) == 1 && resMat(1) ~= -2
                expDes.corTrial = expDes.corTrial+1;
            else
                expDes.incorTrial = expDes.incorTrial+1;
            end
            
            if resMat(3) == -1
                % Break Fixation => send a new trial + save trial configuration for later presentation
                trialDone = 1;
                errorFix(scr,const,my_key)
                if const.eyeMvt && ~const.TEST
                    Eyelink('message', 'TRIAL_END %d',  t);
                    Eyelink('stoprecording');
                end
                expResMat(t,:)= [expDes.expMat(t,:),resMat,eyeCrit];
                csvwrite(const.expRes_fileCsv,expResMat);
                if ~const.mkVideo
                    newJ = newJ+1;
                    expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);
                end
            elseif resMat(3) == 0
                % incorrect saccade
                trialDone = 1;
                expResMat(t,:)= [expDes.expMat(t,:),resMat,eyeCrit];
                csvwrite(const.expRes_fileCsv,expResMat);
                if ~const.mkVideo
                    newJ = newJ+1;
                    expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);
                end
            else
                trialDone = 1;
                expResMat(t,:)= [expDes.expMat(t,:),resMat,eyeCrit];
                csvwrite(const.expRes_fileCsv,expResMat);
            end
        end
    end
    
    % If error of fixation of voluntary missed trial
    if ~newJ
        expDone = 1;
    else
        startJ = endJ+1;
        endJ = endJ+newJ;
        expDes.expMat=[expDes.expMat;expDes.expMatAdd];
        expDes.expMatAdd = [];
        newJ = 0;
    end
end

const.my_clock_end = clock;
const_file = fopen(const.const_fileDat,'a+');
fprintf(const_file,'Ending time :\t%ih%i',const.my_clock_end(4),const.my_clock_end(5));
fclose('all');

if const.eyeMvt && ~const.TEST
    Eyelink('command','clear_screen');
    Eyelink('command', 'record_status_message ''END''');
end
WaitSecs(1);

%% End
if const.eyeMvt && ~const.TEST
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'The end');
end
if const.fromBlock == const.numBlockMainTot                 % /!\ here I delete a reference to a threshold image and also I trash it in the folder
	instructionsIm(scr,const,my_key,'End',1);
else
    instructionsIm(scr,const,my_key,'End_block',1);
end


%% Statistics on online eye criterion
fprintf(1,'\n\n\tTrials correct             = %3.0f (%1.2f)',expDes.corTrial,expDes.corTrial/(expDes.corTrial+expDes.incorTrial));
fprintf(1,  '\n\tTrials incorrect           = %3.0f (%1.2f)',expDes.incorTrial,expDes.incorTrial/(expDes.corTrial+expDes.incorTrial));

matIncor = expResMat(expResMat(:,end-5)~=1,:);

incorFix    = sum(expResMat(:,end-3)==-1);
sacStay     = sum((matIncor(:,end-2)==0));
latTooShort = sum((matIncor(:,end-1)==1));
latTooLong  = sum((matIncor(:,end)==1));

fprintf(1,'\n\n\tIncorrect fixation trials  = %3.0f (%1.2f)',incorFix,incorFix/expDes.incorTrial);
fprintf(1,'  \n\tSaccade stayed in fixation = %3.0f (%1.2f)',sacStay,sacStay/expDes.incorTrial);
fprintf(1,'  \n\tSac latency too short      = %3.0f (%1.2f)',latTooShort,latTooShort/expDes.incorTrial);
fprintf(1,'  \n\tSac latency too long       = %3.0f (%1.2f)',latTooLong,latTooLong/expDes.incorTrial);

end