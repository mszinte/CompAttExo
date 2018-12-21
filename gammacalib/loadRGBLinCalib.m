function [wPtr] = loadRGBLinCalib(wPtr)
% ----------------------------------------------------------------------
% [wPtr] = loadGRAYLinCalib[wPtr]
% ----------------------------------------------------------------------
% Goal of the function :
% Load necessary values to specified RGB and Gray Values in candela/m2 
% and load the linearisation on gray values.
% ----------------------------------------------------------------------
% Input(s) :
% wPtr : window pointer struct
% ----------------------------------------------------------------------
% Output(s):
% wPtr : window pointer struct
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 16 / 08 / 2009
% Project : none
% Version : 1.0
% ----------------------------------------------------------------------

dirC = wPtr.dirCalib;
wPtr.invGammaTable = csvread(sprintf('%s/Gamma/%s/%i/RGB_Lin/InvertGammaTable_%s_%i.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist));

wPtr.RGBparamGamma  = csvread(sprintf('%s/Gamma/%s/%i/RGB_Lin/RGB_ParamFitExtPowerFun_%s_%i.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist));
wPtr.GRAYparamGamma = csvread(sprintf('%s/Gamma/%s/%i/RGB_Lin/GRAY_ParamFitExtPowerFun_%s_%i.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist));

wPtr.tabCalibRed   = csvread(sprintf('%s/Gamma/%s/%i/RGB_Lin/Lin_RedGammaTable_%s_%i.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist));
wPtr.tabCalibGreen = csvread(sprintf('%s/Gamma/%s/%i/RGB_Lin/Lin_GreenGammaTable_%s_%i.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist));
wPtr.tabCalibBlue  = csvread(sprintf('%s/Gamma/%s/%i/RGB_Lin/Lin_BlueGammaTable_%s_%i.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist));
wPtr.tabCalibGray  = csvread(sprintf('%s/Gamma/%s/%i/RGB_Lin/Ini_GrayGammaTable_%s_%i.csv',dirC,wPtr.room,wPtr.dist,wPtr.room,wPtr.dist));

end