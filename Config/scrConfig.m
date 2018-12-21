function [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Give all information about the screen and the monitor.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing subject information and saving files.
% ----------------------------------------------------------------------
% Output(s):
% scr : struct containing all screen configuration.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 05 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

% Number of the exp screen:
scr.all = Screen('Screens');
scr.scr_num = max(scr.all);

% Screen resolution (pixel) :
[scr.scr_sizeX, scr.scr_sizeY]=Screen('WindowSize', scr.scr_num);
if (scr.scr_sizeX ~= const.desiredRes(1) || scr.scr_sizeY ~= const.desiredRes(2)) && const.expStart
    error('Incorrect screen resolution => Please restart the program after changing the resolution to [%i,%i]',const.desiredRes(1),const.desiredRes(2));
end

% Size of the display :
[scr.disp_sizeX,scr.disp_sizeY] = Screen('DisplaySize',scr.scr_num);
scr.disp_sizeX = 480;scr.disp_sizeY=300; % setting for sony GDM-F900

scr.disp_sizeLeft  = round(-scr.disp_sizeX/2);     % physical size of the screen from center to left edge (mm)
scr.disp_sizeRight = round(scr.disp_sizeX/2);      % physical size of the screen from center to top edge (mm)
scr.disp_sizeTop   = round(scr.disp_sizeY/2);      % physical size of the screen from center to right edge (mm)
scr.disp_sizeBot   = round(-scr.disp_sizeY/2);     % physical size of the screen from center to bottom edge (mm)

% Pixels size:
scr.clr_depth = Screen('PixelSize', scr.scr_num);

% Frame rate : (fps)
scr.frame_duration = 1/(Screen('FrameRate',scr.scr_num));
if scr.frame_duration == inf;
    scr.frame_duration = 1/60;
elseif scr.frame_duration == 0;
    scr.frame_duration = 1/60;
end
scr.fd = scr.frame_duration;

% Frame rate : (hertz)
scr.hz = 1/(scr.frame_duration);
if (scr.hz >= 1.1*const.desiredFD || scr.hz <= 0.9*const.desiredFD) && const.expStart && ~strcmp(const.sjct,'DEMO');
    error('Incorrect refresh rate => Please restart the program after changing the refresh rate to %i Hz',const.desiredFD);
end

if strcmp(const.sjct,'Anon');
    warning off;
    Screen('Preference', 'SkipSyncTests', 1);
end

% Subject dist
scr.dist = 60;

% Screen distance (top and bottom from line of sight in mm)
scr.distTop = 610;
scr.distBot = 610;

% Center of the screen :
scr.x_mid = (scr.scr_sizeX/2.0);
scr.y_mid = (scr.scr_sizeY/2.0);
scr.mid   = [scr.x_mid,scr.y_mid];

% Gamma calibration desired test values :
scr.desiredValue = 16;
scr.room = 'r3139sony';
scr.dirCalib = '../../../../GammaCalib';

%% Saving procedure :
scr_file = fopen(const.scr_fileDat,'w');
fprintf(scr_file,'Resolution size X (pxl):\t%i\n',scr.scr_sizeX);
fprintf(scr_file,'Resolution size Y (pxl):\t%i\n',scr.scr_sizeY);
fprintf(scr_file,'Monitor size X (mm):\t%i\n',scr.disp_sizeX);
fprintf(scr_file,'Monitor size Y (mm):\t%i\n',scr.disp_sizeY);
fprintf(scr_file,'Color depth (bit):\t%i\n',scr.clr_depth);
fprintf(scr_file,'Subject distance (cm):\t%i\n',scr.dist);
fprintf(scr_file,'Frame duration (fps):\t%i\n',scr.frame_duration);
fprintf(scr_file,'Refresh Rate (hz):\t%i\n',scr.hz);
fprintf(scr_file,'Experimental room:\t%s',scr.room);
fclose('all');

% .mat file
save(const.scr_fileMat,'scr');

end