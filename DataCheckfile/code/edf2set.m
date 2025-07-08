function [errorlog,outlog,edfheader] = edf2set(edffile,varargin)
    % convert edf file to set file 
    %         edfpath, "string", dir pattern that store edf file, 
    %                          e.g. **/eeg_EOR/edf/
    % option input : outpath, "string", output path to .set file
    %                                   default output path is same as edf
    %                                   file
    %                Rdataf, "string", Raw data folder name, e.g. 'rawData'
    %                Pdataf, "string", Prep data folder name, e.g. 'prepData'
    %                                code will find edf file path that
    %                                contains "rawData" replace to "prepData"
    edfheader = [];
    errorlog = [];
    varnm = varargin(1:2:end);
    varvl = varargin(2:2:end);
    of = false;
    for i = 1:length(varnm)
        nm = varnm{i};
        switch nm
            case 'outpath'
                of = true;
                outpath = varvl{i};
            case 'sess'
                sess = varvl{i};
            case 'sub'
                sub = varvl{i};
            otherwise
                error('do not recognize %s',nm)
        end
    end

    edffile = dir(edffile);
     
    % get log 
    if exist("log.mat",'file')
        load("log.mat");
        if ~exist("sess",'var')
            try
                ses = fieldnames(log);
                sess = ses{cellfun(@(x) contains(edffile(1).folder,x),ses)};
            catch ME
                sess = input('input sess name for log file: ');
            end
        end
    else
        log = struct();
    end
    
    
    outlog = cell(length(edffile),1);
    for nfile = 1:length(edffile)
        % get subject name 
        % condition --> contains 's', length = 4, num of digit is 3 "s023"
        sfold = split(edffile(nfile).folder,filesep);
    
        if ~exist("sub",'var')
            % find subejct name from folder name
            for i = 1:length(sfold)
                sub = sfold{i};
                if length(sub) ~= 4, continue; end
                if ~contains(sub,'s'), continue; end 
                if isstrprop(sub,'digit') ~= logical([0,1,1,1]), continue; end
                f = 1;break;
            end
    
            if ~f
                warning('can not get subject name from folder name in this path %s. Expect name is sxxx(xxx is number)', edffile(nfile).folder);
                sub = input('enter subject id for log file : ');
            end
        end

        try
            % get .edf file data
            EEG = pop_biosig(fullfile(edffile(nfile).folder,edffile(nfile).name));
        catch ME
            eeglab;
            close all;
            EEG = pop_biosig(fullfile(edffile(nfile).folder,edffile(nfile).name));
        end

        edfheader = edfinfo(fullfile(edffile(nfile).folder,edffile(nfile).name));

        % save EEG .set file
        if ~of 
            outpath = edffile(nfile).folder;
        end

        if ~exist(outpath,'dir'), mkdir(outpath); end
        pop_saveset(EEG,'filename',edffile(nfile).name,'filepath',char(outpath));

        % store process log to log
        log(end+1).func = 'edf2set';
        log(end).sess = sess;
        log(end).sub = sub;
        log(end).local = fullfile(edffile(nfile).folder,edffile(nfile).name);
        
        log(end).setpath = fullfile(char(outpath),strrep(edffile(nfile).name,'.edf','.set'));
        log(end).timestamp = string(datetime);
        outlog{nfile} = fullfile(char(outpath),strrep(edffile(nfile).name,'.edf','.set'));

    end
    if isempty(edffile)
        log(end+1).func = 'edf2set';
        log(end).sess = sess;
        log(end).sub = sub;
        log(end).error = sprintf('not find %s folder in %s',sess,sub);
        log(end).timestamp = string(datetime);
    end
    % save("log.mat","log")
end