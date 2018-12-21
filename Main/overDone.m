function overDone(aud,const,vid)
% ----------------------------------------------------------------------
% overDone(aud,const,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Close screen and check transfer of eye-link data to eye-link file.
% ----------------------------------------------------------------------
% Input(s) :
% aud : auditory configurations
% const : struct containing all constant settings.
% vid : video structure
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 05 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

ListenChar(1);
if const.eyeMvt && ~const.TEST 
    statRecFile = Eyelink('ReceiveFile',const.edffilename,const.edffilename);
    
    if statRecFile ~= 0
        fprintf(1,'\n\tEyelink EDF file correctly transfered');
    else
        fprintf(1,'\n\Error in Eyelink EDF file transfer');
        
        statRecFile2 = Eyelink('ReceiveFile',const.edffilename,const.edffilename);
        if statRecFile2 == 0
            fprintf(1,'\n\tEyelink EDF file is now correctly transfered');
        else
            fprintf(1,'\n\n\t!!!!! Error in Eyelink EDF file transfer !!!!!');
            my_sound(9,aud);
        end
    end

    Eyelink('CloseFile');
    WaitSecs(2.0);
    Eyelink('Shutdown');
    WaitSecs(2.0);
    
    oldDir = 'XX.edf';
    newDir = sprintf('%s_B%i.edf',const.sjct,const.fromBlock);
    movefile(oldDir,newDir);
end

timeDur = toc/60;
fprintf(1,'\n\n\tThis part of the experiment took : %2.0f min.\n\n',timeDur);

ShowCursor;
Screen('CloseAll');

if const.mkVideo
    makeVideo(vid);
end

PsychPortAudio('Close');

end