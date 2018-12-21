function [expDes,vid] = getVideoSettings(scr,const,expDes)
% ----------------------------------------------------------------------
% [expDes,vid] = getVideoSettings(scr,const,expDes)
% ----------------------------------------------------------------------
% Goal of the function :
% Select type of trial relative the different variables used in this
% experiment for the only one trial saved later as a video.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% expVar : struct containing all variables configurations.
% const : struct containing all constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg all variable data randomised.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 03 / 03 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

if const.mkVideo
    
    if ~isdir('../demoVid')
        mkdir('../demoVid')
    end
    
    fprintf(1,'\n\n\tVIDEO MODE ACTIVATED...\n');
    
    vid.textVid = [];
    
    for tCond = 1:expDes.nb_cond
        varMat(tCond) = input(sprintf('\n\tCOND %i = ',tCond));
        vid.textVid = [vid.textVid,sprintf('_Cond%iM%i',tCond,varMat(tCond))];
    end
    
    if isempty(tCond);tCond = 0;end
    
    for tVar = 1:expDes.nb_var
        varMat(tCond+tVar) = input(sprintf('\n\tVAR %i = ',tVar));
        vid.textVid = [vid.textVid,sprintf('_Var%iM%i',tVar,varMat(tCond+tVar))];
    end
    
    if isempty(tVar);tVar = 0;end
        
    for tRand = 1:expDes.nb_rand
        varMat(tCond+tVar+tRand) = input(sprintf('\n\tRAND %i = ',tRand));
        vid.textVid = [vid.textVid,sprintf('_Rand%iM%i',tRand,varMat(tCond+tVar+tRand))];
    end
    
    vid.j = 0;
    vid.j1 =0;
    vid.j2 =0;
    vid.j3 =0;
    vid.j4 =0;
    vid.j5 =0;

    vid.sparseFile = round(round(const.nbFramesMax*1.20)/5);

    angleVal = 45;
    addMat      = angleVal;
    
    %% end of specific add
    tRTval = input(sprintf('\n\tReaction time (in seconds) = '));fprintf(1,'\n');
    expDes.timeRTvid = (round(tRTval/scr.frame_duration));
    
    expDes.expMat= [1 1 varMat addMat];
else
    vid =[];
end

