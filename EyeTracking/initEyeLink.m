function [el,const]=initEyeLink(scr,const)
% ----------------------------------------------------------------------
% [el,error]=initEyeLink(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Initializes eyeLink-connection, creates edf-file
% and writes experimental parameters to edf-file
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer.
% const : struct containing many constant configuration.
% ----------------------------------------------------------------------
% Output(s):
% el : eye-link structure.
% const : struct containing edfFileName
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 02 / 05 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

%% Define EDF file name :
const.edffilename = 'XX.edf';

%% Modify different defaults settings :
el=EyelinkInitDefaults(scr.main);
el.backgroundcolour = GrayIndex(el.window);
el.msgfontcolour    = WhiteIndex(el.window);
el.imgtitlecolour   = WhiteIndex(el.window);
el.targetbeep       = 0;
el.feedbackbeep     = 0;

el.calibrationtargetcolour= BlackIndex(el.window);

el.eyeimgsize=50;
EyelinkUpdateDefaults(el);
el.displayCalResults = 1;
el.backgroundcolour = const.colBG;
el.calibrationtargetsize=const.calTargetRadVal;         % radius (pix) of calibration target (used in my modified version of EyelinkDrawCalTarget)
el.calibrationtargetwidth=const.calTargetWidthVal;      % radius (pix) of inside bull's eye of calibration target (used in my modified version of EyelinkDrawCalTarget)
el.txtCol           = 15;
el.bgCol            = 0;
el.targetbeep       = 0;
el.feedbackbeep     = 0;

%% Initialization of the connection with the Eyelink Gazetracker.
if ~const.TEST
    dummymode = 0;
else
    dummymode = 1;
end

if ~EyelinkInit(dummymode)
    fprintf('Eyelink Init aborted.\n');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

%% open file to record data to
res = Eyelink('Openfile', const.edffilename);
if res~=0
    fprintf('Cannot create EDF file ''%s'' ', const.edffilename);
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

% Describe general information on the experiment :
Eyelink('command', 'add_file_preamble_text ''Experiment by Luca Wollenberg''');

% make sure we're still connected.
if Eyelink('IsConnected')~=1 && ~dummymode
    fprintf('Not connected. exiting');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

%% Set up tracker personal configuration :
rand('state',sum(100*clock));
angle = 0:pi/3:5/3*pi;

% compute calibration target locations
[cx1,cy1] = pol2cart(angle,0.6);
[cx2,cy2] = pol2cart(angle+(pi/6),0.45);
cx = round(scr.x_mid + scr.x_mid*[0 cx1 cx2]);
cy = round(scr.y_mid + scr.x_mid*[0 cy1 cy2]);

% order for eyelink
c = [cx(1), cy(1),...   % 1.  center center
     cx(9), cy(9),...   % 2.  center up
     cx(13),cy(13),...  % 3.  center down
     cx(5), cy(5),...   % 4.  left center
     cx(2), cy(2),...   % 5.  right center
     cx(4), cy(4),...   % 6.  left up
     cx(3), cy(3),...   % 7.  right up
     cx(6), cy(6),...   % 8.  left down
     cx(7), cy(7),...   % 9.  right down
     cx(10),cy(10),...  % 10. left up
     cx(8), cy(8),...   % 11. right up
     cx(11),cy(11),...  % 12. left down
     cx(12),cy(12)];    % 13. right down
     
% compute validation target locations (calibration targets smaller radius)
[vx1,vy1] = pol2cart(angle,0.5);
[vx2,vy2] = pol2cart(angle+pi/6,0.35);

vx = round(scr.x_mid + scr.x_mid*[0 vx1 vx2]);
vy = round(scr.y_mid + scr.x_mid*[0 vy1 vy2]);

% order for eyelink
v = [vx(1), vy(1),...   % 1.  center center
     vx(9), vy(9),...   % 2.  center up
     vx(13),vy(13),...  % 3.  center down
     vx(5), vy(5),...   % 4.  left center
     vx(2), vy(2),...   % 5.  right center
     vx(4), vy(4),...   % 6.  left up
     vx(3), vy(3),...   % 7.  right up
     vx(6), vy(6),...   % 8.  left down
     vx(7), vy(7),...   % 9.  right down
     vx(10),vy(10),...  % 10. left up
     vx(8), vy(8),...   % 11. right up
     vx(11),vy(11),...  % 12. left down
     vx(12),vy(12)];    % 13. right down

Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, scr.scr_sizeX-1, scr.scr_sizeY-1);
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, scr.scr_sizeX-1, scr.scr_sizeY-1);

Eyelink('command', 'calibration_type = HV13');
Eyelink('command', 'generate_default_targets = NO');

Eyelink('command', 'randomize_calibration_order 1');
Eyelink('command', 'randomize_validation_order 1');
Eyelink('command', 'cal_repeat_first_target 1');
Eyelink('command', 'val_repeat_first_target 1');

Eyelink('command', 'calibration_samples=14');
Eyelink('command', 'calibration_sequence=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');
Eyelink('command', sprintf('calibration_targets = %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i',c));

Eyelink('command', 'validation_samples=14');
Eyelink('command', 'validation_sequence=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');
Eyelink('command', sprintf('validation_targets = %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i',v));

% Set parser
Eyelink('command', 'file_event_filter = RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', 'file_sample_data  = RIGHT,GAZE,AREA');
Eyelink('command', 'link_event_filter = RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', 'link_sample_data  = RIGHT,GAZE,AREA');

Eyelink('command', 'heuristic_filter = 1 1');

%% Set pupil Tracking model in camera setup screen  (no = centroid. yes = ellipse)
Eyelink('command', 'use_ellipse_fitter =  NO');

%% set sample rate in camera setup screen
Eyelink('command', 'sample_rate = %d',1000);

%% Experiment descriptions into the edf-file :
Eyelink('message', 'BEGIN OF DESCRIPTIONS');
Eyelink('message', '%s', const.sjctCode);
Eyelink('message', 'END OF DESCRIPTIONS');

% Test mode of eyelink connection :
status = Eyelink('IsConnected');
switch status
    case -1
        fprintf(1, '\tEyelink in dummymode.\n\n');
    case  0
        fprintf(1, '\tEyelink not connected.\n\n');
    case  1
        fprintf(1, '\tEyelink connected.\n\n');
end

% make sure we're still connected.
if Eyelink('IsConnected')~=1 && ~dummymode
    fprintf('Not connected. exiting');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

end