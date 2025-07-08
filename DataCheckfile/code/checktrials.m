function [Allres, figData] = checktrials(inputfile, sess, edfhdr, varargin)
    % convert edf file to set file 
    % input : 
    %       inputfile, "string", input file name or pattern
    %                              e.g. E:\SEEG\Data\**\eeg_PN\*.set
    %                                   or E:\SEEG\Data\prepData\s105\eeg_PN\edf\sess1_PN_b03.set
    %         Trialnum, "double", dir pattern that store edf file, 
    %                          e.g. **/eeg_EOR/edf/
    % option input : 
    %       rel_outpath, "string", output path to .set file 
    %                           default path is inputfile
    %       abs_outpath, "string", output path to .set file 
    %                           default path is inputfile
    %       eventName, "string", event name, 
    %                           default : "DC1"
    %       STEDrepTrigger, "double", number of repeated trigger for
    %                                 experiment start and end
    %                                 default is 10

    % get varargin
    varnm = varargin(1:2:end);
    varvl = varargin(2:2:end);
    evtName = "DC1";
    repT = 10;
    for i = 1:length(varnm)
        nm = varnm{i};
        switch nm
            case 'outpath'
                of = true;
                outpath = varvl{i};
            case 'rel_outpath'
                of = true;
                rel_outpath = varvl{i};
            case 'eventName'
                evtName = string(varvl{i});
            case 'STEDrepTrigger'
                repT = varvl{i};
            otherwise
                error('do not recognize input name "%s"',nm)
        end
    end
    

    % =============== get file =================
    file = dir(inputfile);
    % ==========================================
    Allres = table();
    figData = table();
    for nfile = 1:length(file)
        if ~of
            outpath = file(nfile).folder;
        end
        if ~exist(outpath,'dir'), mkdir(outpath); end
        result = struct();
        % load data
        filename = split(file(nfile).name,'.');
        filename = filename{1};
        EEG = pop_loadset(file(nfile).name,file(nfile).folder);
        % check event name exist
        while ~any(string({EEG.chanlocs.labels})==evtName)
            evtName = input(sprintf('\nno event %s, check name and enter event name again : ',evtName),'s');
        end
        sprintf('\nevent channel is %s\n',evtName);

        loggingfile = dir(fullfile(file(nfile).folder,'..','logging','*.txt'));
        loggingfile = fullfile(loggingfile(nfile).folder,loggingfile(nfile).name);

        result.file = {fullfile(file(nfile).folder,file(nfile).name)};
        VarName = {'file'};
        if exist("rel_outpath","var")
            result.figfolder = {fullfile(rel_outpath,[filename,'_',char(evtName),'.fig'])};
            VarName = cat(2,VarName,{'figfolder'});
            result.evtfolder = {fullfile(rel_outpath,['Checkfile',sess,'.xlsx'])};
            VarName = cat(2,VarName,{'evtfolder'});
        else
            result.figfolder = {fullfile(outpath,[filename,'_',char(evtName),'.fig'])};
            VarName = cat(2,VarName,{'figfolder'});
            result.evtfolder = {fullfile(outpath,['Checkfile',sess,'.xlsx'])};
            VarName = cat(2,VarName,{'evtfolder'});
        end
        
        % ================= step 1 get inputfile trial ===================
        % get event time(locs)
        % find EEG labels
        CHNAME = {EEG.chanlocs.labels};
        % get event signal
        event = EEG.data(string(CHNAME)==evtName,:);
        % normalize event signal in 0 to 1
        event = event/max(event);
        % smooth event signal
        event = round(event);
        % find event signal raise
        [locsS, ~] = islocalmax(event,"FlatSelection",'first');
        % find event signal drop
        [locsE, ~] = islocalmax(event,"FlatSelection",'last');

        % define time series
        t = (1:length(event))/EEG.srate;

        % trans locsS and locsE to index number
        locsS = find(locsS);
        locsE = find(locsE);
        % =================================================================
    
        try
            if isempty(locsE) || isempty(locsS)
                figure;
                plot(t,event);
                xlabel('time(s)')
                title(evtName)
                saveas(gcf,fullfile(outpath,[filename,'_',char(evtName),'.fig']));
                close(gcf)
                error('no trigger')
            end
            % === step 2 get start and end trigger (10 trigger in 3 seconds) ===
            % % Trigger duration(s)
            % difT = t(locsE)-t(locsS); 
    
            % find duration is less than 0.3s, suppose start and end repeat trigger
            idx = find((t(locsE)-t(locsS))<0.3); 

            if sess == "eeg_EOR" || sess == "eeg_ECR"
                tmp = find(diff(t(locsS(idx))) < 0.5);
                didx = diff(tmp);
                I = [];
                C = [];
                c = 0;
                for i = 1:length(didx)
                    if didx(i) == 1
                        c = c+1;
                    else
                        I = cat(2,I,i);
                        C = cat(2,C,c);
                        c = 0;
                    end
                    if i == length(didx) && didx(i) == 1
                        I = cat(2,I,i+1);
                        C = cat(2,C,c);
                    end
                end
                I = tmp(I)+1;
                C = C+2;

                I(C < repT/2) = [];
                C(C < repT/2) = [];

                if length(C) ~= 2
                    error('can not find start or end trigger')
                end
                I(2) = I(2)-C(2);
                result.StartTrig = {num2str(C(1))};
                VarName = cat(2,VarName,{'StartTrig(num)'});
                result.EndTrig = {num2str(C(2))};
                VarName = cat(2,VarName,{'EndTrig(num)'});
                expTimeRangeidx = [I(1), I(2)+1];
            else
                % maybe there has other Trigger less than 0.3s, so find the
                % continuous index number
                % idxdif = idx(repT:end)-idx(1:end-(repT-1));
                % expTimeRangeidx = idx(idxdif==repT-1);
                didx = diff(idx);
                I = [];
                C = [];
                c = 0;
                for i = 1:length(didx)
                    if didx(i) == 1
                        c = c+1;
                    else
                        I = cat(2,I,i);
                        C = cat(2,C,c);
                        c = 0;
                    end
                    if i == length(didx) && didx(i) == 1
                        I = cat(2,I,i+1);
                        C = cat(2,C,c);
                    end
                end

                I(C < repT/2) = [];
                C(C < repT/2) = [];
                if length(C) ~= 2
                    error('can not find start or end trigger')
                end
                I(2) = I(2)-C(2);
                result.StartTrig = {num2str(C(1)+1)};
                VarName = cat(2,VarName,{'StartTrig(num)'});
                result.EndTrig = {num2str(C(2)+1)};
                VarName = cat(2,VarName,{'EndTrig(num)'});
                expTimeRangeidx = idx(I);
            end

            % Get Triggers that between start and end repeat trigger
            % difT = difT(expTimeRangeidx(1)+1:expTimeRangeidx(2)-1);
            TriglocsS = locsS(expTimeRangeidx(1)+1:expTimeRangeidx(2)-1);
            TriglocsE = locsE(expTimeRangeidx(1)+1:expTimeRangeidx(2)-1);
            DumLatS = [locsS(1:expTimeRangeidx(1)),locsS(expTimeRangeidx(2):end)];
            DumLatE = [locsE(1:expTimeRangeidx(1)),locsE(expTimeRangeidx(2):end)];

            % check if one trigger is split to two trigger
            tlocsE = t(TriglocsE);
            tlocsS = t(TriglocsS);
            dift = [1,tlocsS(2:end)-tlocsE(1:end-1)];
            for i = 2:length(dift)
                if dift(i) < 0.01
                    TriglocsS(i) = nan;
                    TriglocsE(i-1) = nan;
                end
            end
            TriglocsS(isnan(TriglocsS)) = [];
            TriglocsE(isnan(TriglocsE)) = [];
            difT = t(TriglocsE)-t(TriglocsS);
            
            % plot event red circle is signal raise blue circle is signal drop
            figure;
            plot(t,event,t(TriglocsS),event(TriglocsS),'ro');
            hold on;
            plot(t(DumLatS),event(DumLatS),'ro');
            plot(t(TriglocsE),event(TriglocsE),'bo')
            plot(t(DumLatE),event(DumLatE),'bo');
            xlabel('time(s)')
            title(evtName)
            saveas(gcf,fullfile(outpath,[filename,'_',char(evtName),'.fig']));
            close(gcf)

            % set EEG event
            EEG.event = struct();
            idx = 0;
            Duration = [];
            for i = 1:length(DumLatS)
                idx = idx + 1;
                EEG.event(idx).type = 'DumE';
                EEG.event(idx).latency = DumLatE(i);
                Duration = cat(1,Duration,0.0625);
                idx = idx + 1;
                EEG.event(idx).type = 'DumS';
                EEG.event(idx).latency = DumLatS(i);
                Duration = cat(1,Duration,0.0625);
            end
            for i = 1:length(TriglocsE)
                idx = idx + 1;
                EEG.event(idx).type = 'TE';
                EEG.event(idx).latency = TriglocsE(i);
                Duration = cat(1,Duration,(TriglocsE(i)-TriglocsS(i))/EEG.srate);
                idx = idx + 1;
                EEG.event(idx).type = 'TS';
                EEG.event(idx).latency = TriglocsS(i);
                Duration = cat(1,Duration,(TriglocsE(i)-TriglocsS(i))/EEG.srate);
            end
            [~,i] = sort([EEG.event.latency]);
            EEG.event = EEG.event(i);

            % ouput StartTime(Point) and EndTime(Point)
            result.StartTime = {num2str(t(locsE(expTimeRangeidx(1))))};
            VarName = cat(2,VarName,{'StartTime(s)'});
            result.EndTime = {num2str(t(locsS(expTimeRangeidx(2))))};
            VarName = cat(2,VarName,{'EndTime(s)'});
            result.StartPoint = {num2str(locsE(expTimeRangeidx(1)))};
            VarName = cat(2,VarName,{'StartPoint(index)'});
            result.ENDPoint = {num2str(locsS(expTimeRangeidx(2)))};
            VarName = cat(2,VarName,{'EndPoint(index)'});
    
            % =================================================================
            
            % ======== step 3 get trigger number between start and end ========
            
            
            Trial_Dur = round(difT,1);
            ProcName = dictionary('eeg_PN', {{'CuingProc','NoCueProc'}}, ...
                                 'eeg_WM', {{'TrialProc','Cue2BackProc','Cue0BackProc'}}, ...
                                 'eeg_emotion',{{'TrialProc'}}, ...
                                 'eeg_music',{{'TrialProc'}}, ...
                                 'eeg_EOR',{{}}, ...
                                 'eeg_ECR',{{}}, ...
                                 'eeg_blink',{{'TrialProc'}});
            evtN = dictionary( 'eeg_PN', {{'TarDur','RespDur','Resp.RT'}}, ...
                                'eeg_WM', {{'Stim.OnsetToOnsetTime'}}, ...
                                'eeg_emotion',{{'T3_dur'}}, ...
                                'eeg_music',{{'StimDur'}}, ...
                                'eeg_EOR',{{}}, ...
                                'eeg_ECR',{{}}, ...
                                'eeg_blink',{{'PicDur'}});
            
            
            % maxnum = max(values(splitTrial));
            [VarName,result] = getTrialsinfo(Trial_Dur, result, VarName);
            [VarName,result] = getTrialsinfo_EDat(loggingfile,result,VarName,ProcName{sess},evtN{sess},sess);
            
            % =================================================================
            % step 4 output excel file with struct
            % file | Trialnum | start time | end time |
            L = zeros(1,length(fieldnames(result)));
            F = fieldnames(result);
            for i = 1:length(fieldnames(result))
                L(i) = length(result.(F{i}));
            end
            maxL = max(L);
            for i = 1:length(fieldnames(result))
                if size(result.(F{i}),1) ~= maxL
                    result.(F{i}) = [result.(F{i});cell(maxL-size(result.(F{i}),1),1)];
                end
            end
            result = struct2table(result);
            result.Properties.VariableNames = VarName;
            writetable(result,fullfile(outpath,['Checkfile',sess,'.xlsx']),"Sheet",[filename,'_',char(evtName)]);    
        catch ME
            result.error = ME.message;
            result = struct2table(result);
            writetable(result,fullfile(outpath,['Checkfile',sess,'.xlsx']),"Sheet",[filename,'_',char(evtName)]);
        end
        Prop = result.Properties.VariableNames;
        switch sess
            case "eeg_EOR"
                result.("DurTrig") = cellfun(@num2str,num2cell(str2double(result.("EndTime(s)"))-str2double(result.("StartTime(s)"))),'UniformOutput',false);
            case "eeg_ECR"
                result.("DurTrig") = cellfun(@num2str,num2cell(str2double(result.("EndTime(s)"))-str2double(result.("StartTime(s)"))),'UniformOutput',false);
            case "eeg_music"
                result.("DurTrig") = cellfun(@num2str,result.("DurTrig(s)"),'UniformOutput',false);
                result.("edatTrig") = cellfun(@num2str,num2cell(cell2mat(result.("edatTrig(ms)"))/1000),'UniformOutput',false);
               
        end
        for j = 1:length(Prop)
            CName = [sess,'_file',num2str(nfile)];
            d = result.(Prop{j});

            if Prop{j}=="DurTrig(s)" || Prop{j}=="edatTrig(ms)"
               continue;
            end
            
 
            if class(d) == "cell"
                d = d(~cellfun(@isempty,d));
                if length(d) > 1 || isempty(d), continue; end
                
            elseif class(d) == "double"
                d = d(~isnan(d)); 
                if length(d) > 1 || isempty(d), continue; end
                d = {num2str(d)};
            else
                d = {d};
            end
            Allres(CName,Prop{j}) = d;
        end
        % ============================================================
        % save EEG file
        pop_saveset(EEG,'filepath',file(nfile).folder,'filename',[file(nfile).name]);

        % % save .edf file
        % hdr = edfheader("EDF+");
        % 
        % finf = fieldnames(hdr);
        % for i = 1:length(finf)
        %     hdr.(finf{i}) = edfhdr.(finf{i});
        % end
        % % hdr.PhysicalMax = single(edfhdr.PhysicalMax);
        % % hdr.PhysicalMin = single(edfhdr.PhysicalMin);
        % 
        % hdr.NumSignals = length(EEG.chanlocs);
        % hdr.DataRecordDuration = seconds(size(EEG.data,2)/EEG.srate);
        % hdr.NumDataRecords = 1;
        % PhysicalNum = sort([hdr.PhysicalMin,hdr.PhysicalMax],2);
        % hdr.PhysicalMin = PhysicalNum(:,1);
        % hdr.PhysicalMax = PhysicalNum(:,2);
        % 
        % % hdr.PhysicalMin = [];
        % % hdr.PhysicalMax = [];
        % 
        % Data = EEG.data';
        % Data = mat2cell(Data,ones(1,size(EEG.data,1)),))
        % 
        % filename = [file(nfile).name];
        % filename = split(filename,'.');
        % filename = [filename{1},'.edf'];
        % filename = [filename{1},'.gdf'];
        % filepath = fullfile(file(nfile).folder,'..','edf');
        % if ~exist(filepath,'dir'), mkdir(filepath); end
        % 
        % Onset = seconds([EEG.event.latency]/EEG.srate)';
        % Duration = seconds(Duration);
        % Annotations = string({EEG.event.type})';
        % annotationslist = timetable(Onset,Annotations,Duration);
        % 
        % EDFWrite(fullfile(filepath,filename),hdr,Data,annotationslist);
    end
    % save check file
    writetable(Allres,fullfile(outpath,['Checkfile',sess,'.xlsx']),"Sheet",['ALL_',sess]);

end

function [VarName,result] = getTrialsinfo(Trial_Dur, result, VarName)
    result.DurTrig = num2cell(Trial_Dur');
    VarName = cat(2,VarName,{'DurTrig(s)'});
    result.DurTrig_L = {num2str(length(Trial_Dur'))};
    VarName = cat(2,VarName,{'DurTrig'});
end


function [VarName,result] = getTrialsinfo_EDat(loggingfile,result,VarName,ProcName,evtName,sess)
    logging = edat2table(loggingfile);
    idx = false(size(logging,1),1);
    for i = 1:length(ProcName)
        tmp = cellfun(@(x) any(x==string(ProcName{i})),logging.Procedure);
        idx = idx | tmp;
    end
    logging = logging(idx,:);
    res = [];
    for i = 1:length(evtName)
        res = cat(2,res,logging.(evtName{i}));
    end
    if sess == "eeg_WM"
        idx = cellfun(@(x) any(contains(x,'BackProc')),logging.Procedure);
        res(idx) = {2500};
    end
    result.edatTrialDur = reshape(res',[],1);
    VarName = cat(2,VarName,{'edatTrig(ms)'});
    result.edatTrialDur_L = {num2str(length(reshape(res',[],1)))};
    VarName = cat(2,VarName,{'edatTrig'});
end