function [errorlog,outlog] = edf2set(datapath,edfpath,varargin)
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

        end
    end

    edffile = dir(fullfile(datapath,edfpath,'**','*.edf'));
    % --------------------------get subject name
    % suggest all edffile path are same except subject name 
    % try 
    %     folders = {edffile.folder};
    %     folders = string(split(folders',filesep));
    %     if size(folders,1) == 1
    %         folders = folders';
    %     end
    %     f = false;
    %     % check 1.
    %     % if folder name contains 's' and number then suggest
    %     % this folder is subject id
    %     id = cell(length(edffile),1);
    %     for i = 1:size(folders,1) % n file 
    %         for j = 1:size(folders,2) % n subfolder
    %             subfold = folders(i,j);
    %             % check this subfolder has number index
    %             numf = isstrprop(subfold,'digit');
    %             % check this subfolder 's' index
    %             sf = char(subfold) == 's';
    %             if any(numf) || any(sf) 
    %                 id{i} = subfold;
    %             end
    %         end
    %     end
    %     if all(~cellfun(@isempty ,id)), f = true;end
    %     if ~f
    %         logary = true(1,size(folders,2));
    %         for i = 1:length(edffile)-1
    %             logary = all([logary;folders(i,:)==folders(i+1,:)]);
    %         end
    %         if sum(~logary) == 1
    %             f = true;
    %             id = convertStringsToChars(folders(:,~logary));
    %         end
    %     end
    % catch ME
    %     errorlog = cat(1,errorlog,ME);
    % end
    outlog = cell(length(edffile),1);
    for nfile = 1:length(edffile)
        % get .edf file data
        EEG = pop_biosig(fullfile(edffile(nfile).folder,edffile(nfile).name));

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
        outlog{nfile} = char(outpath);
    end

end