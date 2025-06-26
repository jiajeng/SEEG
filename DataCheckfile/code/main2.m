%% input data

% define variable
sessFolder = dictionary('eor','eeg_EOR', ...
                        'ecr','eeg_ECR', ...
                        'blink','eeg_blink', ...
                        'emotion','eeg_emotion', ...
                        'music','eeg_music', ...
                        'pn','eeg_PN', ...
                        'wm','eeg_WM');

logFolder = dictionary('eor','EyeOpen', ...
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
while ~exist(datapath,"dir") || ~debugF
    datapath = input([warnmsg,imsg,],'s');
    if ~exist(datapath,"dir")
        if datapath == ""
            debugF = true;
            fprintf('\n debug mode ... \n')
            break;
        end
        warnmsg = sprintf('\n %s is not a direction\n',datapath); 
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
    imsg = '\nEnter subject id(multiple subject split by space, e.x. sub001 sub002) : ';
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
                    'one file split to all sessions(1)\n ' ...
                    'already split to all sessions needs to organize file(0)\n ' ...
                    'no need deal with files(-1)\n ' ...
                    ': ']); 
   if abs(Flag_org_split) > 1, fprintf('input is 0, 1, -1'); end
end

if Flag_org_split~=1
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
if Flag_org_split==0
    %% organize data
    for nsub = 1:length(sub)
        % check if need organize file
        subpath = fullfile(datapath,sub{nsub});
        Fder = {dir(subpath).name};
        if any(contains(Fder,'edf')) && any(contains(Fder,'logging'))
            % edf file
            movfile(subpath,sess,sessFolder,'edf',[])
            % logging file
            movfile(subpath,sess,sessFolder,'logging',logFolder)
        end
        sess = sessFolder(sess);
        sess = cellfun(@char,sess,'UniformOutput',false);
        checkfile(datapath,sub{nsub},sess,true,evtName,[])
    end
elseif Flag_org_split==1
    %% one file split data
    for nsub = 1:length(sub)
        subpath = fullfile(datapath,sub{nsub});
        if ~debugF
            file = input('\nEnter all experiment .edf file(include filepath and filename) : ','s');
            logfold = input('\nEnter logging files folders : ','s');
            imsg = '\nEnter experiment sessions order(split with space) : ';
            sessorders = inputData(imsg,'session',sessinputName);
        else
            file = 'E:\SEEG\Data\test\edf\s109.edf';
            logfold = 'E:\SEEG\Data\test\logging';
            sessorders = {'ecr','eor','music_1','music_2','music_3','music_4','music_5','music_6','blink','pn_1','pn_2','emotion_1','emotion_2','emotion_3','eor','ecr'};
            sess = {'eor','ecr','music','pn','emotion','blink'};
        end
        
        
        [edfhdr,sess] = splitfile(file,evtName,subpath,logfold);
        sess = num2cell(sessFolder(lower(sess)));
        sess = cellfun(@char,sess,'UniformOutput',false);
        sess = flip(sess);
        if ~exist("edfhdr",'var'), load('tmp.mat'); end
        checkfile(datapath,sub{nsub},sess,false,evtName,edfhdr)
    end
end



%% function define
function checkfile(datapath,sub,sess,edffile,evtName,edfhdr)
    repT = dictionary('eeg_EOR', 5, ...
                'eeg_ECR',5, ...
                'eeg_blink',5, ...
                'eeg_emotion',10, ...
                'eeg_music',10, ...
                'eeg_PN',10, ...
                'eeg_WM',10);
    Checkfilefilename = 'Checkfile.xlsx';
    checkallTab = table();
    for nsess = 1:length(sess)
        ckfilepath = fullfile(datapath,sub,sess{nsess},'checkfile');
        ckfilepath_rel = fullfile('.',sess{nsess},'checkfile');
        if edffile
            % ========convert .edf data to .set file=========
            [~,~,edfhdr] = edf2set(fullfile(datapath,'**',sub,sess{nsess},'edf','*.edf'), ...
                               'outpath', fullfile(datapath,sub,sess{nsess},'set'), ...
                               'sess',sess{nsess}, ...
                               'sub',sub);
            % ================================================
        end

        % ============== check Trial number ==============
        [checkTab] = checktrials(fullfile(datapath,sub,sess{nsess},'set','*.set'), sess{nsess}, edfhdr, ...
            'outpath',ckfilepath, ...
            'rel_outpath',ckfilepath_rel, ...
            'eventName',evtName, ...
            'STEDrepTrigger',repT(sess{nsess}));
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


function movfile(subpath,sess,sessFolder,edforlog,logFolder)
    Fder = {dir(fullfile(subpath,edforlog)).name};
    if isempty(logFolder)
        LFder = lower(Fder);
    end
    % session
    for nsess = 1:length(sess)
        if isempty(logFolder)
            file = Fder(contains(LFder,sess{nsess}));
        else
            file = Fder(contains(Fder,logFolder(sess{nsess})));
        end
        sesspath = fullfile(subpath,char(sessFolder(sess{nsess})),edforlog);
        if ~exist(sesspath,'dir'), mkdir(sesspath); end
        for nfile = 1:length(file)
            if sess{nsess} == "eor" || sess{nsess} == "ecr"
                copyfile(fullfile(subpath,edforlog,file{nfile}),fullfile(sesspath));
            else
                movefile(fullfile(subpath,edforlog,file{nfile}),fullfile(sesspath));
            end
        end
    end
    % mapping
    if edforlog == "edf"
        pat = {'1hz.edf','50hz.edf'};
        Foldn = {'eeg_1hz_ep','eeg_50hz_ep'};
        for nfile = 1:length(pat)
            file = Fder(contains(Fder,pat{nfile}));
            sesspath = fullfile(subpath,Foldn{nfile},edforlog);
            if ~exist(sesspath,'dir'), mkdir(sesspath); end
            movefile(fullfile(subpath,edforlog,char(file)),fullfile(sesspath))
        end
    end
end