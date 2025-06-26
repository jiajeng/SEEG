function [edfhdr,sess] = splitfile(file,evtChName,subpath,logfold)
    while ~exist(file,'file') || ~contains(file,'.')
        file = strrep(file,filesep,'/');
        imsg = sprintf(['\nUnable to find or open %s. Check the path and filename or file permissions.\n' ...
                        'Enter filepath again: '], file);
        file = input(imsg,'s');
    end
    fprintf('reading file %s ...\n',file)
    if ~exist('tmp.mat','file')
        tic;
        % edfhdr = edfinfo(file);
        edfhdr = [];
        try
            % get .edf file data
            tic;
            EEG = pop_biosig(file);
            toc;
        catch ME
            eeglab;
            close all;
            EEG = pop_biosig(file);
        end
        toc;
    else
        load('tmp.mat')
    end
    try
        Trig = EEG.data(string({EEG.chanlocs.labels})==string(evtChName),:);
        Trig = Trig/max(Trig);
        % smooth event signal
        Trig = round(Trig);
        t = (1:length(Trig))/EEG.srate;
        % find event signal raise
        [locsS, ~] = islocalmax(Trig,"FlatSelection",'first');
        % find event signal drop
        [locsE, ~] = islocalmax(Trig,"FlatSelection",'last');
    
        locsS = find(locsS);
        locsE = find(locsE);
        TrigDur = (locsE-locsS)/EEG.srate;
    
        % find start and end 
        idx = find(TrigDur<0.3);
        dDur = diff(locsS(idx)/EEG.srate);
        
        Dt = dDur<0.3;
    
        c = cell(2,sum(Dt==0));
        tmp = [];
        count = 1;
        for i = 1:length(Dt)
            if ~Dt(i)
                c(1,count) = {sum(tmp)};  
                c(2,count) = {i};
                tmp = [];
                count = count+1;
            else
                tmp = cat(2,tmp,Dt(i));
                if i == length(Dt)
                    c(1,count) = {sum(tmp)};  
                    c(2,count) = {i+1};  
                end
            end
        end
        c(:,cellfun(@(x) x==0,c(1,:))) = [];
        locsidx = idx(cell2mat(c(2,:)));
        LOCSIDX = cell(length(locsidx),1);
        for i = 1:length(locsidx)
            n = c{1,i};
            LOCSIDX{i} = locsidx(i)-n:locsidx(i);
        end
    
        % check Which is true Start Dummys and End Dummys
        % (abort experiment ...)
        i = 1;
        N = cell(size(LOCSIDX));
        while i < length(LOCSIDX)
            S = LOCSIDX{i};
            E = LOCSIDX{i+1};
            % 1. check Start and End Dummys number is same
            if abs(length(S)-length(E))>2
                LOCSIDX(i) = {[]};
                i = i+1;
                continue;
            end
            % 2. check inter Dummys Triggers number 
            %    if is empty check the duration is around 3 min
            InterTrigDur = (t(locsE(S(end)+1:E(1)-1))-t(locsS(S(end)+1:E(1)-1)));
            if isempty(InterTrigDur)
                % check duration is around 3 min?
                InterTrigDur = t(locsE(E(1)))-t(locsE(S(end)));
                if InterTrigDur<190 && InterTrigDur>170
                    % rest
                    N(i) = {'restS'};
                    N(i+1) = {'restE'};
                    i = i+2;
                else
                    % unknown
                    LOCSIDX(i) = {[]};
                    i = i+1;
                end
            else
                % InterTrigNum = length(InterTrigDur);
                if length(InterTrigDur) > 216-10 && length(InterTrigDur) < 216+10
                    % pn 216
                    N(i) = {'pnS'};
                    N(i+1) = {'pnE'};
                    i = i+2;
                elseif length(InterTrigDur) > 88-5 && length(InterTrigDur) < 88+5
                    % wm 88
                    N(i) = {'wmS'};
                    N(i+1) = {'wmE'};
                    i = i+2;
                    
                elseif length(InterTrigDur) > 23-5 && length(InterTrigDur) < 23+5
                    % emotion 23
                    N(i) = {'emotionS'};
                    N(i+1) = {'emotionE'};
                    i = i+2;
                elseif length(InterTrigDur) == 1
                    % music 1
                    mf1 = InterTrigDur>270-5 && InterTrigDur<270+5;
                    mf2 = InterTrigDur>181-5 && InterTrigDur<181+5;
                    mf3 = InterTrigDur>364-5 && InterTrigDur<364+5;
                    if mf1 || mf2 || mf3
                        N(i) = {'musicS'};
                        N(i+1) = {'musicE'};
                        i = i+2;
                    else
                        LOCSIDX(i) = {[]};
                        i = i+1;
                    end
                elseif length(InterTrigDur)>96-5 && length(InterTrigDur)<96+5
                    % blink
                    N(i) = {'blinkS'};
                    N(i+1) = {'blinkE'};
                    i = i+2;
                   
                else
                    % unknown
                    LOCSIDX(i) = {[]};
                    i = i+1;
                end
            end
            % 3. 
        end
            
        LOCSIDX(cellfun(@isempty,LOCSIDX)) = [];
        N(cellfun(@isempty,N)) = [];
    
    
        % from logging file to find sessions order
        logtxtfile = dir(fullfile(logfold,'*.txt'));
        logfile = dir(logfold);
        logfile = logfile(3:end);
        logtxtfile = cat(1,logtxtfile,logtxtfile(contains({logtxtfile.name},'EyeOpen-n-EyeClosed')));
        logfile = cat(1,logfile,logfile(contains({logfile.name},'EyeOpen-n-EyeClosed')));
        Nlog = length(logtxtfile);
        
        while Nlog ~= length(N)/2
            fprintf('Detect logging file(%d) is not same as Detect event sessions from DC1(%d)',Nlog,length(N)/2)
            F = input('check logging file,\n continue?(y/n)','s');
            logtxtfile = dir(fullfile(logfold,'*.txt'));
            Nlog = length(logtxtfile)+sum(contains({logtxtfile.name},'EyeOpen-n-EyeClosed'));
            if F == "n"
                return
            end
        end
        
        [~,idx] = sort([logtxtfile.datenum]);
        logtxtfile = logtxtfile(idx);
        [~,idx] = sort([logfile.datenum]);
        logfile = logfile(idx);
    
        Rf = 1;
        sess = [];
        for i = 1:2:length(N)
            j = round(i/2);
            % check log file session is same as Detect
            if contains(logtxtfile(j).name,'EyeOpen-n-EyeClosed') && contains(N(i),'rest')
                % rest  
                % check which first eor or ecr
                logTab = edat2table(fullfile(logtxtfile(j).folder,logtxtfile(j).name));
                proc = logTab.Procedure;
                proc = proc(contains(proc,'Block'));
                if mod(Rf,2),rf = 1; else,rf = 2; end
                if contains(proc(rf),'EyeClosed'), proc = 'ECR'; elseif contains(proc(rf),'EyeOpen'), proc = 'EOR'; end
                Rf = Rf+1;
                
            elseif contains(logtxtfile(j).name,'music') && contains(N(i),'music')
                % music
                
                proc = 'music';
    
            elseif contains(logtxtfile(j).name,'PicNaming') && contains(N(i),'pn')
                % pn
                proc = 'PN';
    
            elseif contains(logtxtfile(j).name,'emoclips') && contains(N(i),'emotion')
                % emotion
                proc = 'emotion';
                
            elseif contains(logtxtfile(j).name,'EyeBlink') && contains(N(i),'blink')
                % blink
                proc = 'blink';
                
            elseif contains(logtxtfile(j).name,'wm_4sets') && contains(N(i),'wm')
                % wm
                proc = 'WM';
            else
                figure;
                plot(t,Trig);
                error('Check is Detect Event is wrong(figure), or logging file is wrong(according to logging file date modified)?')
            end
            sess = cat(2,sess,{proc});
            filepath = fullfile(subpath,['eeg_',proc],'set');
            logpath = fullfile(subpath,['eeg_',proc],'logging');
            if ~exist(filepath,'dir'), mkdir(filepath); end
            if ~exist(logpath,'dir'), mkdir(logpath); end
            
            filename = ['sess01_',proc,'_b',sprintf('%02d',j)];
    
            pEEG = pop_select(EEG,'point',[locsS(LOCSIDX{i})-EEG.srate,locsE(LOCSIDX{i+1})+EEG.srate]);
            pop_saveset(pEEG,'filename',filename,'filepath',filepath)
    
            % copy logging file
            for idx = (j-1)*3+1:(j*3)
                copyfile(fullfile(logfile(idx).folder,logfile(idx).name),fullfile(logpath,logfile(idx).name));
            end
        end
    
        % Start Dummys and End Dummys
        TrigEIDX = cell2mat(cellfun(@(x) locsE(x),LOCSIDX,'UniformOutput',false)');
        TrigSIDX = cell2mat(cellfun(@(x) locsS(x),LOCSIDX,'UniformOutput',false)');
    
        figure;
        plot(t,Trig);
        hold on;
        plot(t(TrigSIDX),Trig(TrigSIDX),'ro');
        hold on;
        plot(t(TrigEIDX),Trig(TrigEIDX),'bo');
        
        saveas(gcf,fullfile(dir(file).folder,'all_dum_label.fig'))
        sess = unique(sess);

    catch ME
        if ~exist('tmp.mat','file')
            save('tmp.mat','EEG',"edfhdr")
        end
        rethrow(ME)
    end
end