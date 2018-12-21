function [scr,const]=constColor(scr,const)
% ----------------------------------------------------------------------
% [scr,const]=constColor(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute color with or without gamma linearisation
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containg previous constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% scr : window pointer
% const : struct containing all constant data.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 02 / 05 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

if const.expStart
    % Color
    scr.black       =   BlackIndex(scr.scr_num);
    scr.white       =   cdpms2gun(scr,56,'gray');    scr.white   =  scr.white(1);
    scr.gray        =   cdpms2gun(scr,28,'gray');    scr.gray    =  scr.gray(1);
    const.red15     =   cdpms2gun(scr,15,'red');
    const.colST     =   cdpms2gun(scr,42,'gray');    const.colST = const.colST(1)    % this corresponds to 75 percent of the maximum white
else
    % Color
    scr.black       =   BlackIndex(scr.scr_num);
    scr.white       =   WhiteIndex(scr.scr_num);
    scr.gray        =   GrayIndex(scr.scr_num);
    const.red15     =   [255 0 0];
    const.colST     =   WhiteIndex(scr.scr_num)*0.75;
end

% Stim color
const.colFix                = scr.white;
const.colBG                 = scr.gray;
const.colWaitSpace          = const.red15;
const.colCheckFix           = scr.white;
const.colErrFix             = scr.black;
const.colTarDot             = scr.black;
const.colTarCtrDot          = scr.white;
const.colTarCtrCtrDot       = scr.black;
end