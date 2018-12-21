function [const] = sbjConfig(const)
% ----------------------------------------------------------------------
% [const]=sbjConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Take subject and block configuration.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Luca WOLLENBERG (wollenberg.luca@gmail.com)
% Last update : 01 / 05 / 2016
% Project :     CompAtt
% Version :     11.0
% ----------------------------------------------------------------------

if const.expStart
    if ~const.mkVideo
        const.sjct =  upper(strtrim(input(sprintf('\n\tInitials: '),'s')));
    else
        fprintf(1,'\n\tInitials: DEMO\n');
        const.sjct = 'DEMO';
    end
    
    if ~const.TEST && const.eyeMvt && ~strcmp(const.sjct,'DEMO');
        const.sjct_DomEye=  upper(strtrim(input(sprintf('\n\tRecorded Eye (R or L): '),'s')));
        if strcmp(const.sjct_DomEye,'L')
            const.recEye = 1;
        elseif strcmp(const.sjct_DomEye,'R')
            const.recEye = 2;
        else
            error('Restart and please enter a correct value (L or R).');
        end
    else
        const.sjct_DomEye = 'DM';
        const.recEye = 2;
    end
    
    const.sjct_name = sprintf('%s_%s',const.sjct,const.expName);
    const.sjctCode  = sprintf('%s_%s',const.sjct_name,const.sjct_DomEye);

    firstRes = 0;
    for tB = 1:const.numBlockMainTot
        resExist = exist(sprintf('Data/%s_data/ExpDataMAIN/Block%i/%s_B%i.edf',const.sjct_name,tB,const.sjct,tB));
        if resExist == 0 && ~firstRes
            firstRes =1;
            const.fromBlock = tB;
            fprintf(1,'\n\tFrom Block nb: %i\n',const.fromBlock);
        end
    end
     
    if const.fromBlock == 1 && ~strcmp(const.sjct,'DEMO');
        const.sjct_age = input(sprintf('\n\tAge: '));
        const.sjct_gender = upper(strtrim(input(sprintf('\n\tGender (M or F): '),'s')));
    else
        const.sjct_age = 'XX';
        const.sjct_gender = 'X';
    end

    if strcmp(const.sjct(end),'2')
        const.condition = 2;
    else 
        const.condition = 1;
    end
    
else
    const.sjct = 'Anon';
    const.sjct_name = 'Anon';
    const.sjct_age = 'XX';
    const.sjct_gender = 'X';
    const.sjct_DomEye = 'TM';
    const.sjctCode = strcat(const.sjct_name,'_Test');
    const.recEye = 2;
    const.fromBlock = 1;fprintf(1,'\n\tFrom Block nb: 1\n\n');
    const.condition =  str2double(strtrim(input(sprintf('\n\tCondition (1) saccade to target (2) saccade in between:\t'),'s')));
    
end

end