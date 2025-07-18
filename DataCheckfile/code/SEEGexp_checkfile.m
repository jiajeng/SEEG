clear all; close all;
%% input data
% define variable
wkdir = pwd;
sessFolder = dictionary('eor','eeg_EOR', ...
                        'ecr','eeg_ECR', ...
                        'blink','eeg_blink', ...
                        'emotion','eeg_emotion', ...
                        'music','eeg_music', ...
                        'pn','eeg_PN', ...
                        'wm','eeg_WM');

logfilepat = dictionary('eor','EyeOpen', ...
                       'ecr','EyeClosed', ...
                       'blink','EyeBlink', ...
                       'emotion','emoclips', ...
                       'music','music', ...
                       'pn','PicNaming', ...
                       'wm','wm');


Checkfilefilename = 'Checkfile.xlsx';
sessinputName = {'eor','ecr','blink','emotion','music','wm','pn'};
debugF = false;

% datapath
datapath = '';
imsg = '\nEnter subject datapath : ';
warnmsg = '';
while ~exist(datapath,"dir")
    datapath = input([warnmsg,imsg,],'s');
    if ~exist(datapath,"dir")
        if datapath == "debug"
            debugF = true;
            fprintf('\n debug mode ... \n')
            break;
        end
        warnmsg = sprintf('\n %s is not a direction\n',datapath); 
    end
    if debugF
       break; 
    end
end

if debugF
    datapath = 'E:\SEEG\Data';
    sub = {'test'};
    evtName = "DC1";
else
    % sub id
    tmp = {dir(datapath).name};
    f = true;
    imsg = '\nEnter subject id(multiple subject split by space, e.x. s001 s002) : ';
    warnmsg = '';
    while f
        f = false;
        ls(datapath)
        sub = input([warnmsg,imsg],'s');
        sub = split(sub,' ');
        for nsub = 1:length(sub)
            if ~any(sub{nsub} == string(tmp))
                f = true;
                warnmsg = sprintf('\n unrecognize sub id "%s"\n',sub{nsub});
            end
        end
    end
    
    % trigger channel name
    evtName = input('\nEnter event CHANNEL name : ','s');
end

% process flag
Flag_org_split = 2;
while abs(Flag_org_split) > 1
   Flag_org_split = input(['\nWhich preprocessing needs to do ?\n' ...
                    ' move sessions file to sessions folder(0)\n ' ...
                    'one file split to all sessions(1)\n ' ...
                    'no need deal with files(-1)\n ' ...
                    ': ']); 
   if abs(Flag_org_split) > 1, fprintf('input is 0, 1, -1'); end
end

if Flag_org_split==-1
    % sessions
    imsg = ['\nEnter experiment session (split by space, e.x. EOR ECR Blink) \n ' ...
            ' session name \n ' ...
            '   EOR, ' ...
            '   ECR, ' ...
            '   Blink, ' ...
            '   PN, ' ...
            '   WM, ' ...
            '   music, ' ...
            '   emotion \n : '];

    sess = inputData(imsg,'session',sessinputName);
end

% main
WRNMSG = cell(length(sub),1);
if Flag_org_split==0
    %% organize data
    subpath = fullfile(datapath,sub{nsub});
    for nsub = 1:length(sub)
        if nsub == 1
            disp('select edf files folder ...')
            edffold = uigetdir(subpath,'select edf files folder ...');
            disp('select logging files folder ...')
            logfold = uigetdir(subpath,'select logging files folder ...');
        else
            edffold = strrep(edffold,sub{nsub-1},sub{nsub});
            logfold = strrep(logfold,sub{nsub-1},sub{nsub});
        end
        % check if need organize file
        sess = {'eor','ecr','music','pn','emotion','blink','wm'};
        % edf file
        [edfsess,wrnmsg] = movfile(subpath,sess,sessFolder,edffold,[]);
        if ~isempty(wrnmsg), wrnmsg = [{'move edf file : '};wrnmsg;{' '}]; end
        WRNMSG{nsub} = cat(1,WRNMSG{nsub},wrnmsg);
        % logging file
        [logsess,wrnmsg] = movfile(subpath,sess,sessFolder,logfold,logfilepat);
        if ~isempty(wrnmsg), wrnmsg = [{'move logging file : '};wrnmsg;{' '}];end
        WRNMSG{nsub} = cat(1,WRNMSG{nsub},wrnmsg);
        rmdir(edffold,'s');
        rmdir(logfold,'s');
        sess = unique([edfsess,logsess]);
        sess = sessFolder(sess);
        sess = cellfun(@char,sess,'UniformOutput',false);
        [wrnmsg] = checkfile(datapath,sub{nsub},sess,true(1,length(sess)),evtName,[]);
        if ~isempty(wrnmsg), wrnmsg = [{'checkfile : '};wrnmsg;{' '}];end
        WRNMSG{nsub} = cat(1,WRNMSG{nsub},wrnmsg);
    end
elseif Flag_org_split==1
    %% one file split data
    for nsub = 1:length(sub)
        subpath = fullfile(datapath,sub{nsub});
        if ~debugF
            cd(subpath)
            disp('select all experiment .edf file ...')
            [file,filepath] = uigetfile('*.edf','select all experiment .edf file ...');
            file = fullfile(filepath,file);
            cd(wkdir)
            disp('select logging files folder ...')
            logfold = uigetdir(subpath,'select logging files folder ...');
        else
            file = 'E:\SEEG\Data\test\edf\s109.edf';
            logfold = 'E:\SEEG\Data\test\logging';
            % sessorders = {'ecr','eor','music_1','music_2','music_3','music_4','music_5','music_6','blink','pn_1','pn_2','emotion_1','emotion_2','emotion_3','eor','ecr'};
            sess = {'eor','ecr','music','pn','emotion','blink'};
        end
        
        [edfhdr,sess,wrnmsg,evtName] = splitfile(file,evtName,subpath,logfold);
        if ~isempty(wrnmsg),wrnmsg = [{'splitfile : '};wrnmsg;{' '}];end
        WRNMSG{nsub} = cat(1,WRNMSG{nsub},wrnmsg);
        sess = num2cell(sessFolder(lower(sess)));
        sess = cellfun(@char,sess,'UniformOutput',false);
        sess = flip(sess);
        if ~exist("edfhdr",'var'), load('tmp.mat'); end
        [wrnmsg] = checkfile(datapath,sub{nsub},sess,false(1,length(sess)),evtName,edfhdr);
        if ~isempty(wrnmsg),wrnmsg = [{'checkfile : '};wrnmsg;{' '}];end
        WRNMSG{nsub} = cat(1,WRNMSG{nsub},wrnmsg);
    end
else
    sess = sessFolder(sess);
    sess = cellfun(@char,sess,'UniformOutput',false);
    edffile = false(1,length(sess));
    for nsess = 1:length(sess)
        if ~any(contains({dir(fullfile(datapath,sub{nsub},sess{1})).name},'set')), edffile(nsess)=true; end
    end
    for nsub = 1:length(sub)
        [wrnmsg] = checkfile(datapath,sub{nsub},sess,edffile,evtName,[]);
        wrnmsg = [{'checkfile : '};wrnmsg;{' '}];
        WRNMSG{nsub} = cat(1,WRNMSG{nsub},wrnmsg);
    end
end

% display report 
for nsub = 1:length(sub)
    subpath = fullfile(datapath,sub{nsub});
    wrnmsg = WRNMSG{nsub};

    writecell(wrnmsg,fullfile(subpath,'report.txt'),'Delimiter','|')
    wrnmsg = strjoin(wrnmsg,'\n');
    wrnmsg = strrep(wrnmsg,'\','\\');

    fprintf('========= %s =========\n',sub{nsub})
    fprintf([wrnmsg,'\n']);
    fprintf('======================\n')
end



%% function define
function [wrnmsg,errorMsg] = checkfile(datapath,sub,sess,edffile,evtName,edfhdr)
    wrnmsg = [];
    errorMsg = [];
    repT = dictionary('eeg_EOR', 5, ...
                'eeg_ECR',5, ...
                'eeg_blink',5, ...
                'eeg_emotion',10, ...
                'eeg_music',10, ...
                'eeg_PN',10, ...
                'eeg_WM',10);
    Checkfilefilename = 'Checkfile.xlsx';
    checkallTab = table();
    checkTab = [];
    for nsess = 1:length(sess)
        ckfilepath = fullfile(datapath,sub,sess{nsess},'checkfile');
        ckfilepath_rel = fullfile('.',sess{nsess},'checkfile');
        if edffile(nsess)
            % ========convert .edf data to .set file=========
            [~,~,edfhdr] = edf2set(fullfile(datapath,'**',sub,sess{nsess},'edf','*.edf'), ...
                               'outpath', fullfile(datapath,sub,sess{nsess},'set'), ...
                               'sess',sess{nsess}, ...
                               'sub',sub);
            % ================================================
        end

        try
            % ============== check Trial number ==============
            [checkTab] = checktrials(fullfile(datapath,sub,sess{nsess},'set','*.set'), sess{nsess}, edfhdr, ...
                'outpath',ckfilepath, ...
                'rel_outpath',ckfilepath_rel, ...
                'eventName',evtName, ...
                'STEDrepTrigger',repT(sess{nsess}));
            % ================================================


            % ============== check event num =================
            % compare trigger(DC1) and logging file 
            switch sess{nsess}
                case 'eeg_blink'
                    % Triggers number
                    sigTri = checkTab.("DurTrig");
                    edatTri = checkTab.("edatTrig");
                    
                    for i = 1:size(checkTab,1)
                        if sigTri{i} ~= edatTri{i}
                            file = split(checkTab.file(i),filesep);
                            file = file(end);
                            wrnmsg = cat(1,wrnmsg,{sprintf('%s signal Trigger number(%s) is not same as edata Trigger number(%s).',string(file),sigTri{i},edatTri{i})});
                        end
                    end
                case 'eeg_ECR'
                    % duration
                    durtime = str2double(checkTab.("EndTime(s)"))-str2double(checkTab.("StartTime(s)"));
                    for i = 1:size(durtime,1)
                        if durtime(i) < 170 || durtime(i) > 190
                            file = split(checkTab.file(i),filesep);
                            file = file(end);
                            wrnmsg = cat(1,wrnmsg,{sprintf('%s duration is %.2f, expect between 170 ~ 190',string(file),durtime(i))});
                        end
                    end
                case 'eeg_emotion'
                    % Triggers number
                    sigTri = checkTab.("DurTrig");
                    edatTri = checkTab.("edatTrig");
                    
                    for i = 1:size(checkTab,1)
                        if sigTri{i} ~= edatTri{i}
                            file = split(checkTab.file(i),filesep);
                            file = file(end);
                            wrnmsg = cat(1,wrnmsg,{sprintf('%s signal Trigger number(%s) is not same as edata Trigger number(%s).',string(file),sigTri{i},edatTri{i})});
                        end
                    end

                case 'eeg_EOR'
                    % duration
                    durtime = str2double(checkTab.("EndTime(s)"))-str2double(checkTab.("StartTime(s)"));
                    for i = 1:size(durtime,1)
                        if durtime(i) < 170 || durtime(i) > 190
                            file = split(checkTab.file(i),filesep);
                            file = file(end);
                            wrnmsg = cat(1,wrnmsg,{sprintf('%s duration is %.2f, expect between 170 ~ 190',string(file),durtime(i))});
                        end
                    end
                case 'eeg_music'
                    % Triggers number
                    sigTri = checkTab.("DurTrig");
                    edatTri = checkTab.("edatTrig");
                    
                    for i = 1:size(checkTab,1)
                        if sigTri{i} ~= edatTri{i}
                            file = split(checkTab.file(i),filesep);
                            file = file(end);
                            wrnmsg = cat(1,wrnmsg,{sprintf('%s signal Trigger number(%s) is not same as edata Trigger number(%s).',string(file),sigTri{i},edatTri{i})});
                        end
                    end
                case 'eeg_PN'
                    % Triggers number
                    sigTri = checkTab.("DurTrig");
                    edatTri = checkTab.("edatTrig");
                    
                    for i = 1:size(checkTab,1)
                        if sigTri{i} ~= edatTri{i}
                            file = split(checkTab.file(i),filesep);
                            file = file(end);
                            wrnmsg = cat(1,wrnmsg,{sprintf('%s signal Trigger number(%s) is not same as edata Trigger number(%s).',string(file),sigTri{i},edatTri{i})});
                        end
                    end
            end
            % ================================================

            % ========= put all subject in one table =========
            checkTab.Properties.RowNames = strcat([sub,'_'],checkTab.Properties.RowNames);
            checkTab = [cell2table(checkTab.Properties.RowNames,'VariableNames',{'id'}),checkTab];
            checkTab(end+1,:) = cell(1,size(checkTab,2));
            checkTab.Properties.RowNames = [checkTab.Properties.RowNames(1:end-1); {['Row',num2str(size(checkTab,1)+size(checkallTab,1))]}];
    
            if isempty(checkallTab)
                checkallTab = cat(1,checkallTab,checkTab);
            else
                varallName = unique([checkallTab.Properties.VariableNames,checkTab.Properties.VariableNames]);
                varName = checkallTab.Properties.VariableNames;
                varName = varallName(~any(cell2mat(cellfun(@(x) contains(varallName,x),varName,'UniformOutput',false)'),1));
    
                for i = 1:length(varName)
                    checkallTab(:,varName{i}) = cell(size(checkallTab,1),1);
                end
    
                varallName = unique([checkallTab.Properties.VariableNames,checkTab.Properties.VariableNames]);
                varName = checkTab.Properties.VariableNames;
                varName = varallName(~any(cell2mat(cellfun(@(x) contains(varallName,x),varName,'UniformOutput',false)'),1));
    
                for i = 1:length(varName)
                    checkTab(:,varName{i}) = cell(size(checkTab,1),1);
                end
    
                checkallTab = cat(1,checkallTab,checkTab);
            end

        catch ME
            msgText = getReport(ME);
            msgText = split(msgText,newline);
            idx = find(contains(msgText,ME.stack(1).name) & contains(msgText,num2str(ME.stack(1).line)))+1;
            if contains(msgText{idx}, "loggingfile = fullfile(loggingfile(nfile).folder,loggingfile(nfile).name);")
                wrnmsg = cat(1,wrnmsg,{sprintf('error in "%s", no logging file',sess{nsess})});
            else
                rethrow(ME);
            end
            errorMsg = cat(1,errorMsg,{ME});
        end

        
        
        % ================================================
    end
    if ~exist(ckfilepath,'dir'), mkdir(ckfilepath); end
    writetable(checkallTab,fullfile(datapath,sub,Checkfilefilename),"Sheet",sub);
    addhyperLink2cell(fullfile(datapath,sub,Checkfilefilename),sub,{"figfolder","evtfolder"})
end


function o = inputData(imsg,n,bn)
    f = 1;
    warnmsg = '';
    while f
        f = 0;
        o = input([warnmsg,imsg,],'s');
        o = lower(o);
        o = split(o,' ');
        o = unique(o);
        o(cellfun(@isempty,o)) = [];
        for i = 1:length(o)
            if ~any(o{i} == string(bn))
                f = 1;
                warnmsg = sprintf('\n unrecognize %s "%s" \n',n,o{i});
                break;
            end
        end
    end
end

function addhyperLink2cell(file,sheet,COLNAME)
    Data = readcell(file,'Sheet',sheet);
    for j = 1:length(COLNAME)
        COLNUM = find(cellfun(@(x) any(x==COLNAME{j}),Data(1,:)));
        figfolder = Data(:,COLNUM);
        colnum = [];
        tmp = COLNUM;
        for i = 1:ceil((log10(COLNUM)/log10(26)))
            colnum = cat(2,colnum,mod(tmp,26));
            tmp = (tmp-mod(tmp,26))/26;
        end
        COLNUM = flip(colnum);
        COL = char(64+COLNUM);
        
        exl = actxserver('excel.application');
        exlWkbk = exl.Workbooks;
        exlFile = exlWkbk.Open(file); %outputfile.xlsx must be present in current working directory
        exlSheet1 = exlFile.Sheets.Item(sheet);
        
        for i=2:length(figfolder)
            if ~ismissing(figfolder{i})
                rngObj = get(exlSheet1,'Range',[COL,num2str(i)]); 
                exlSheet1.HyperLinks.Add(rngObj, figfolder{i});
            end
        end
        exlFile.Save();
        exlFile.Close();
        exl.Quit;
        exl.delete;
    end
end


function [osess,wrnmsg] = movfile(subpath,sess,sessFolder,filepath,logfilepat)
    wrnmsg = [];
    Fder = {dir(fullfile(filepath)).name};
    F_log = 'logging';
    if isempty(logfilepat)
        LFder = lower(Fder);
        F_log = 'edf';
    end
    % session
    osess = [];
    for nsess = 1:length(sess)
        if isempty(logfilepat)
            file = Fder(contains(LFder,sess{nsess}));
        else
            file = Fder(contains(Fder,logfilepat(sess{nsess})));
        end
        sesspath = fullfile(subpath,char(sessFolder(sess{nsess})),F_log);
        if ~exist(sesspath,'dir'), mkdir(sesspath); end
        for nfile = 1:length(file)
            if sess{nsess} == "eor" || sess{nsess} == "ecr"
                copyfile(fullfile(filepath,file{nfile}),fullfile(sesspath));
            else
                movefile(fullfile(filepath,file{nfile}),fullfile(sesspath));
            end
        end
        if isempty(file)
            wrnmsg = cat(1,wrnmsg,{sprintf('no "%s" %s file',sess{nsess},F_log)});
            rmdir(sesspath)
            try
                rmdir(fullfile(subpath,char(sessFolder(sess{nsess}))))
            end
        else
            osess = cat(2,osess,sess(nsess));
        end
    end

    % mapping
    if F_log == "edf"
        pat = {'1hz.edf','50hz.edf'};
        Foldn = {'eeg_1hz_ep','eeg_50hz_ep'};
        for nfile = 1:length(pat)
            file = Fder(contains(Fder,pat{nfile}));
            sesspath = fullfile(subpath,Foldn{nfile},F_log);
            if ~isempty(file)
                if ~exist(sesspath,'dir'), mkdir(sesspath); end
                movefile(fullfile(filepath,char(file)),fullfile(sesspath))
            else
                wrnmsg = cat(1,wrnmsg,{sprintf('can not find "%s" in %s, so not move %s file',pat{nfile},filepath,pat{nfile})});
            end
        end
    end
end