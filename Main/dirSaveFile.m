function [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% [const]=dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 05 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

%% Directory
if ~isdir(sprintf('Data/%s_data',const.sjct_name));
    mkdir(sprintf('Data/%s_data',const.sjct_name));
    cd (sprintf('Data/%s_data',const.sjct_name));
else
    cd (sprintf('Data/%s_data',const.sjct_name));
end

const.typeTask = 'MAIN';


if const.expStart 

    expDir = sprintf('ExpData%s/Block%i',const.typeTask,const.fromBlock);
    if ~isdir(expDir) || strcmp(const.sjct,'DEMO');
        mkdir(expDir);
        cd(expDir);
    else
        aswErase = input('\n This file allready exist, do you want to erase it ? (Y or N)    ','s');
        if upper(aswErase) == 'N'
            error('Please restart the program with correct input.')
        elseif upper(aswErase) == 'Y'
            cd(expDir);
        else
            error('Incorrect input => Please restart the program with correct input.')
        end
    end
    
else
    const.c = clock;
    debugDir = sprintf('DebugData%s/%i-%i_trials/',const.typeTask,const.c(2),const.c(3));
    if ~isdir(debugDir);
        mkdir(debugDir);
        cd (debugDir);
    else
        cd (debugDir);
    end
end

%% Saving Files
const.scr_fileDat =         sprintf('scr_file%s.dat',const.sjctCode);
const.scr_fileMat =         sprintf('scr_file%s.mat',const.sjctCode);
const.aud_fileMat =         sprintf('aud_file%s.mat',const.sjctCode);
const.const_fileDat =       sprintf('const_file%s.dat',const.sjctCode);
const.const_fileMat =       sprintf('const_file%s.mat',const.sjctCode);
const.expRes_fileCsv =      sprintf('expRes%s.csv',const.sjctCode);
const.expRes_fileMat =      sprintf('expRes%s.mat',const.sjctCode);
const.design_fileDat =      sprintf('design%s.dat',const.sjctCode);
const.design_fileMat =      sprintf('design%s.mat',const.sjctCode);

addpath('../../../../Config',...
        '../../../../Main',...
        '../../../../Conversion',...
        '../../../../EyeTracking',...
        '../../../../Instructions',...
        '../../../../Trials',...
        '../../../../Stim',...
        '../../../../GammaCalib',...
        '../../../../Video');

end