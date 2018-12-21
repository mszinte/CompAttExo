function [wPtr]=gammaCalib(wPtr,const,my_key,textExp,button)
% ----------------------------------------------------------------------
% [wPtr]=gammaCalib(wPtr,const,my_key,textExp,button)
% ----------------------------------------------------------------------
% Goal of the function :
% Measure/Find and load gamma correction for luminance, main file.
% ----------------------------------------------------------------------
% Input(s) :
% wPtr : window pointer struct
% const : struct containing previous constant configurations.
% my_key : struct containing button response configurations. 
% textExp : struct containing instruction text.
% button :  struct containing button text.
% ----------------------------------------------------------------------
% Output(s):
% wPtr : struct containing window pointer configuration
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 18 / 08 / 2010
% Project : -
% Version : 1.0
% ----------------------------------------------------------------------

close('all'),
dirC = wPtr.dirCalib;

if const.calibFlag == 1             % Do gamma calibration
    ListenChar(2)
    if const.calibType == 1         % Gray linearized calibration done
       
        [wPtr,f]=grayLinCalib(wPtr,const,my_key,textExp,button);        % Linearized screen on gray values
        [wPtr]=grayCheckCalib(wPtr,const,my_key,textExp,button,f);      % Check correct linearization and get gray params
        [wPtr]=getRGBcalibVal(wPtr,const,my_key,textExp,button);        % Get RGB values 
        
    elseif const.calibType == 2     % RGB linearized calibration done
        
        [wPtr,f]=rgbLinCalib(wPtr,const,my_key,textExp,button);         % Linearized screen on RGB values
        [wPtr]=rgbCheckCalib(wPtr,const,my_key,textExp,button,f);       % Check correct linearization and get RGB params
        [wPtr]=getGRAYcalibVal(wPtr,const,my_key,textExp,button);       % Get gray values
    end
    
elseif const.calibFlag  == 0           % Load gamma calibration
    if const.calibType == 1         % Gray linearized calibration loaded
        [wPtr] = loadGRAYLinCalib(wPtr);
    elseif const.calibType == 2     % RGB linearized calibration loaded
        [wPtr] = loadRGBLinCalib(wPtr);
    end
    loadgammaCalib(wPtr,const);    
end

%% SAVING FILE

if const.calibFlag == 1 
    if const.calibType == 1
        calibFileDir = sprintf('%s/Gamma/%s/%i/GRAY_Lin/GammaCalibration.txt',dirC,wPtr.room,wPtr.dist);
        typeCal = 'GRAY linearized';
    elseif  const.calibType == 2
        calibFileDir = sprintf('%s/Gamma/%s/%i/RGB_Lin/GammaCalibration.txt',dirC,wPtr.room,wPtr.dist);
        typeCal = 'RGB linearized';
    end

    fid = fopen(calibFileDir,'w');

    fprintf(fid,'\n\n\t ----------------------------------- \n');
    fprintf(fid,'\t|         Gamma calibration           |\n');
    fprintf(fid,'\t ----------------------------------- \n');

    fprintf(fid,sprintf('\n\t Screen ID : \t\t\t%s',wPtr.room));
    fprintf(fid,sprintf('\n\t Screen distance : \t\t%i cm',wPtr.dist));
    fprintf(fid,sprintf('\n\t Calibration type : \t%s',typeCal));
    fprintf(fid,sprintf('\n\t Creation date : \t\t%s',date));
    my_clock = clock;
    fprintf(fid,sprintf('\n\t Creation time : \t\t%i:%i',my_clock(4),my_clock(5)));
    fprintf(fid,sprintf('\n\n\t Max RED lum. : \t\t%i',wPtr.tabCalibRed(end,end)));
    fprintf(fid,sprintf('\n\t Max GREEN lum. : \t\t%i',wPtr.tabCalibGreen(end,end)));
    fprintf(fid,sprintf('\n\t Max BLUE lum. : \t\t%i',wPtr.tabCalibBlue(end,end)));
    fprintf(fid,sprintf('\n\t Max GRAY lum. : \t\t%i',wPtr.tabCalibGray(end,end)));
    
    
end
