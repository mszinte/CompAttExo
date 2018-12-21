function [rgb]=cdpms2gun(wPtr,candelaVal,colorAsk)
% ----------------------------------------------------------------------
% [rgb]=cdpms2gun(wPtr,const,candelaVal,colorAsk)
% ----------------------------------------------------------------------
% Goal of the function :
% Give the triplet gun values for the desired gray or RGB in candela/m2
% ----------------------------------------------------------------------
% Input(s) :
% wPtr : window pointer struct
% const : struct containing previous constant configurations.
% candelaVal = desired candela val
% colorAsk = color wanted ('red','green','blue','gray')
% ----------------------------------------------------------------------
% Output(s):
% [rgb] = Gun values in RGB (0->255)
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 16 / 08 / 2009
% Project : none
% Version : 1.0
% ----------------------------------------------------------------------

switch colorAsk
    case 'red'
        if candelaVal > wPtr.tabCalibRed(end,end) 
            candelaVal = wPtr.tabCalibRed(end,end);
        end
        rgb = [1 0 0]*InvertGammaExtP([wPtr.RGBparamGamma(1,1),wPtr.RGBparamGamma(2,1)],255,candelaVal/wPtr.tabCalibRed(end,end));
    case 'green'
        if candelaVal > wPtr.tabCalibGreen(end,end)
            candelaVal = wPtr.tabCalibGreen(end,end);
        end
        rgb = [0 1 0]*InvertGammaExtP([wPtr.RGBparamGamma(1,2),wPtr.RGBparamGamma(2,2)],255,candelaVal/wPtr.tabCalibGreen(end,end));
    case 'blue'
        if candelaVal > wPtr.tabCalibBlue(end,end)
            candelaVal = wPtr.tabCalibBlue(end,end);
        end
        rgb = [0 0 1]*InvertGammaExtP([wPtr.RGBparamGamma(1,3),wPtr.RGBparamGamma(2,3)],255,candelaVal/wPtr.tabCalibBlue(end,end));
    case 'gray'
        if candelaVal > wPtr.tabCalibGray(end,end)
            candelaVal = wPtr.tabCalibGray(end,end);
        end
        rgb = [1 1 1]*InvertGammaExtP([wPtr.GRAYparamGamma(1),wPtr.GRAYparamGamma(2)],255,candelaVal/wPtr.tabCalibGray(end,end));
end

end