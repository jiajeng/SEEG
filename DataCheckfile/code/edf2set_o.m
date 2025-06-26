function [errorlog,outlog] = edf2set(datapath,edffile,varargin)
    % convert edf file to set file 
    % input : datapath, "string", datapath that store all data
    %         edfpath, "string", dir pattern that store edf file, 
    %                          e.g. **/eeg_EOR/edf/
    % option input : outpath, "string", output path to .set file
    %                                   default output path is same as edf
    %                                   file
    %                Rdataf, "string", Raw data folder name, e.g. 'rawData'
    %                Pdataf, "string", Prep data folder name, e.g. 'prepData'
    %                                code will find edf file path that
    %                                contains "rawData" replace to "prepData"
    errorlog = [];

    varnm = varargin(1:2:end);
    varvl = varargin(2:2:end);
    of = false;
    Rf = false;
    Pf = false;
    for i = 1:length(varnm)
        nm = varnm{i};
        switch nm
            case 'outpath'
                of = true;
                outpath = varvl{i};
            case 'Rdataf'
                Rf = true;
                Rdataf = varvl{i};
            case 'Pdataf'
                Pf = true;
                Pdataf = varvl{i};
            case 'sess'
                sess = varvl{i};
            case 'sub'
                Dsub = varvl{i};
            otherwise
                error('do not recognize %s',nm)
        end
    end

    edffile = dir(fullfile(datapath,edffile,'**','*.edf'));
     
    % get info 
    if exist("info.mat",'file')
        load("info.mat");
        infos = {info.(sess).sub};
    else
        info = struct();
        if ~exist("sess",'var')
            sess = input('input sess name : ');
        end
        info.(sess) = [];
    end
    
    idx = false(1,length(edffile));
    if exist("Dsub",'var')
        for i = 1:length(Dsub)
            fold = {edffile.folder};
            idx = contains(fold,Dsub{i}) | idx;
        end
        edffile = edffile(idx);
    end
    outlog = cell(length(edffile),1);
    for nfile = 1:length(edffile)
        % get subject name 
        % condition --> contains 's', length = 4, num of digit is 3 "s023"
        sfold = split(edffile(nfile).folder,filesep);
    
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
            continue;
        end

        try
            % get .edf file data
            EEG = pop_biosig(fullfile(edffile(nfile).folder,edffile(nfile).name));
        catch ME
            eeglab;
            close all;
            EEG = pop_biosig(fullfile(edffile(nfile).folder,edffile(nfile).name));
        end

        % save EEG .set file
        if ~of 
            if Rf && Pf
                try
                    outpath = strrep(edffile(nfile).folder,Rdataf,Pdataf);
                catch 
                    outpath = edffile(nfile).folder;
                end
            else
                outpath = edffile(nfile).folder;
            end
        end

        if ~exist(outpath,'dir'), mkdir(outpath); end
        pop_saveset(EEG,'filename',edffile(nfile).name,'filepath',char(outpath))

        % store process info to info
        % if exist old info 
        if exist("infos",'var')
            % get old sub name indx
            idx = string(sub) == string(infos);
            if any(idx)
            info.(sess)(idx).local = edffile(nfile).folder;
            info.(sess)(idx).setpath = char(outpath);
            else
                info.(sess)(end+1).sub = sub;
                info.(sess)(end).local = edffile(nfile).folder;
                info.(sess)(end).setpath = char(outpath);
            end
            infos = {info.(sess).sub};
        else
            info.(sess)(end+1).sub = sub;
            info.(sess)(end).local = edffile(nfile).folder;
            info.(sess)(end).setpath = char(outpath);
            infos = {info.(sess).sub};
        end
        outlog{nfile} = char(outpath);
    end
    save("info.mat","info")
end