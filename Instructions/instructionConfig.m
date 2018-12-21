function [textExp,button] = instructionConfig
% ----------------------------------------------------------------------
% [textExp,button] = instructionConfig
% ----------------------------------------------------------------------
% Goal of the function :
% Write text of calibration and general instruction for the experiment.
% ----------------------------------------------------------------------
% Input(s) :
% (none)
% ----------------------------------------------------------------------
% Output(s):
% textExp : struct containing all text of general instructions.
% button : struct containing all button instructions.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 01 / 04 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

%% Screen gamma linearisation calibration
calibScreen_l1  = 'Gamma linearisation :';
calibScreen_l2  = '';
calibScreen_l3  = 'A white dot on a black square will appear, focus the photometer,';
calibScreen_l4  = 'to this white dot and press any button.';
calibScreen_l5  = '';
calibScreen_l6  = 'A colored screen will appear, measure it s luminance,';
calibScreen_l7  = 'then press [RETURN] button. ';
calibScreen_l8  = 'Enter the measured values, then press again [RETURN] button.';
calibScreen_l9  = '';
calibScreen_l10  = 'Keep continue until a new screen appears, telling you that';
calibScreen_l11  = 'the calibration is done.';
calibScreen_l12  = '';
calibScreen_b1 = '-----------------  PRESS [SPACE] TO CONTINUE  -----------------';

textExp.calibScreen = {calibScreen_l1;calibScreen_l2;calibScreen_l3;calibScreen_l4;calibScreen_l5;...
                       calibScreen_l6;calibScreen_l7;calibScreen_l8;calibScreen_l9;calibScreen_l10;calibScreen_l11;calibScreen_l12};
button.calibScreen = {calibScreen_b1};

%% Screen gamma linearisation calibration end :
calibScreenEnd_l1 = 'Gamma linarisation measurments correctly done.' ;
calibScreenEnd_b1 = '--------------------  PRESS [SPACE] TO CONTINUE  -------------------';

textExp.calibScreenEnd = {calibScreenEnd_l1};
button.calibScreenEnd =  {calibScreenEnd_b1};

%% Calibration eye-tracker :
calib_l1  = 'Calibration :';
calib_l2  = '';
calib_l3  = 'A gray screen will appear, press [C] button.';
calib_l4  = 'A white dot will appear, fixate it and press [RETURN] button. ';
calib_l5  = 'Other dots will appear, fixate them until they disappear.';
calib_l6  = '';
calib_l7  = 'An other gray screen will appear, press [V] button.';
calib_l8  = 'Fixate the dot, press [RETURN] and do the same thing as just before.';
calib_l9  = '';
calib_l10 = 'Press then [ESCAPE] button, to start a new trial.';
calib_b1 = '-----------------  PRESS [SPACE] TO CONTINUE  -----------------';

textExp.calib = {calib_l1;calib_l2;calib_l3;calib_l4;calib_l5;...
                 calib_l6;calib_l7;calib_l8;calib_l9;calib_l10};
button.calib = {calib_b1};

%% Pause : 
pause_l1 = 'Pause :';
pause_l2 = 'Take a break, close your eyes but do not move your head.';
pause_b1 = '-----------------  PRESS [SPACE] TO CONTINUE  -----------------';

textExp.pause = {pause_l1;pause_l2};
button.pause = {pause_b1};

%% End :
end_l1 = 'Thank you ...';
end_b1 = '--------------------  PRESS [SPACE] TO QUIT  -------------------';

textExp.end = {end_l1};
button.end =  {end_b1};

%% Main instruction :
instruction_l1  = 'Task instruction :';
instruction_l2  = '';
instruction_l3  = '';
instruction_l4  = '';
instruction_l5  = '';
instruction_l6  = '';
instruction_l7  = '';
instruction_l8  = '';
instruction_l9  = '';
instruction_l10 = '';

instruction_b1 = '-----------------  PRESS [SPACE] TO CONTINUE  -----------------';

textExp.instruction1= {instruction_l1;instruction_l2;instruction_l3;instruction_l4;instruction_l5;instruction_l6;...
                       instruction_l7;instruction_l8;instruction_l9;instruction_l10};
button.instruction1 =  {instruction_b1};

end