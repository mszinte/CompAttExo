function [wPtr,f]=grayLinCalib(wPtr,const,my_key,textExp,button)
% ----------------------------------------------------------------------
% [wPtr,f]=grayLinCalib(wPtr,const,my_key,textExp,button)
% ----------------------------------------------------------------------
% Goal of the function :
% Measure and linearised the screen on gray values.
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
% f : figure handle
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 12 / 08 / 2009
% Project : none
% Version : 1.0
% ----------------------------------------------------------------------

% initial setting
dirC = wPtr.dirCalib;
if ~isdir(sprintf('%s/Gamma/',dirC));mkdir(sprintf('%s/Gamma/',dirC));end
if ~isdir(sprintf('%s/Gamma/%s/',dirC,wPtr.room));mkdir(sprintf('%s/Gamma/%s/',dirC,wPtr.room));end
if ~isdir(sprintf('%s/Gamma/%s/%i/',dirC,wPtr.room,wPtr.dist));mkdir(sprintf('%s/Gamma/%s/%i/',dirC,wPtr.room,wPtr.dist));end
if ~isdir(sprintf('%s/Gamma/%s/%i/GRAY_Lin/',dirC,wPtr.room,wPtr.dist));mkdir(sprintf('%s/Gamma/%s/%i/GRAY_Lin/',dirC,wPtr.room,wPtr.dist));end

const.focusRadVal = 1.0;const.focusRad = vaDeg2pix(const.focusRadVal,wPtr);

tabCalibGray    = [];
valTest = round(linspace(0,255,wPtr.desiredValue));
black=[0,0,0];red=[1,0,0];green=[0,1,0];blue=[0,0,1];
light_black = [0.5,0.5,0.5]; light_red = [1,0.5,0.5];light_green = [0.5,1,0.5];light_blue = [0.5,0.5,1];

% Open a screen
[wPtr.main,wPtr.rect] = Screen('OpenWindow',wPtr.scr_num,[0 0 0],[], wPtr.clr_depth,2);
Screen('BlendFunction', wPtr.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
priorityLevel = MaxPriority(wPtr.main);Priority(priorityLevel);

% Instruction
instructions(wPtr,const,my_key,textExp.calibScreen,button.calibScreen);

% Photometer Set up
const
my_circle(wPtr.main,255,wPtr.x_mid,wPtr.y_mid,const.focusRad/2);
Screen('Flip',wPtr.main);
while KbCheck(-1); end
KbWait(-1);


% Take the initial values
for t = 1:wPtr.desiredValue
    press_enter = 0;
    while ~press_enter
        while KbCheck(-1); end
        colDisplay = valTest(t)*[1 1 1];
        Screen(wPtr.main,'FillRect',colDisplay);
        Screen('Flip',wPtr.main);
        if CharAvail
            if GetChar(0,1) == 10
                press_enter = 1;
            end
        end
    end
    [lineCalib]=waitValues(wPtr,const,colDisplay);
    tabCalibGray  = [tabCalibGray;lineCalib];
end

% Save and quit the screen
csvwrite(sprintf('%s/Gamma/%s/%i/GRAY_Lin/Ini_GrayGammaTable_%s_%i.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist),tabCalibGray);
instructions(wPtr,const,my_key,textExp.calibScreenEnd,button.calibScreenEnd);
Screen('closeAll');


% Display the values
f=figure();
name = ('Gamma Linearisation - GRAY linearisation');
set(f, 'Name', name,'PaperOrientation', 'portrait','PaperUnits','points','PaperPosition', [0,400,600,250]);
figSize_X = 600;
figSize_Y = 1000;res = figSize_X/figSize_Y;
start_X = 0;start_Y = 0;
set(f,'Position',[start_X,start_Y,figSize_X+start_X,figSize_Y+start_Y]);
col_b  =  black;col_r  =  red;col_g  =  green;col_bl =  blue;


gunValues       = valTest;
lumValues(:,1)  = tabCalibGray(:,4);
typicalGammaInput = gunValues';
typicalGammaData = NormalizeGamma(lumValues(:,1:end)); % nomalize measures
output = [0:255]';

% Plot the data measured

for t = 1:4
    subplot(4,2,t)    
    plot(gunValues,typicalGammaData(:,1),'Color',col_b,'Marker','s','MarkerEdgeColor',black,'MarkerSize',6,'MarkerFaceColor',col_b,'LineStyle','none');
    hold on;

    xlabel('Gun');
    ylabel('Normalized luminance');
    title('Measured values normalized');
    set(gca,'XLim',[-5,260],'YLim',[-0.1,1.1])

    % Fit different functions
    [valFit,paramFit] = FitGamma(typicalGammaInput,typicalGammaData,output,t);

    plot(output,valFit(:,1),'--','Color',col_b,'LineWidth',1.2);
    hold on;

    switch t
        case 1;nameFit = '1 = Power function';
        case 2;nameFit = '2 = Extended power function';
        case 3;nameFit = '3 = Sigmoid';
        case 4;nameFit = '4 = Weibull';
        case 5;nameFit = '5 = Modified polynomial';
        case 6;nameFit = '6 = Linear interpolation';
        case 7;nameFit = '7 = Cubic spline';
    end
    title(nameFit);
    ListenChar(1);
end
answ = input('Fit prefered (1-4)?');

[gammaTable,paramFit]= FitGamma(typicalGammaInput,typicalGammaData,output,answ);

% Compute and save linearized values
invGammaTable = InvertGammaTable(linspace(0,1,256)',gammaTable,256);
wPtr.invGammaTable = invGammaTable*[1 1 1];
csvwrite(sprintf('%s/Gamma/%s/%i/GRAY_Lin/InvertGammaTable_%s_%i.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist),wPtr.invGammaTable);

end
