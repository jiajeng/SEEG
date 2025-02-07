ftpServer.ip = '140.119.165.35';
ftpServer.account = 'nlabuser01';
ftpServer.password = 'nissen6034';
ftpServer.infolder = '/space/maki7/nissen_eegmri/tasked_seeg/rawdata/';
ftpServer.localfolder = 'E:\SEEG\Data\rawData';
sess = {'eeg_EOR'};
ftp2local(ftpServer,sess,'subject',{'s011','s013'})

datapath = 'E:\SEEG\Data';

% load("info.mat");

for i = 1:length(sess)
    % --------------convert .edf data to .set file-----------------------------
    [errorlog,setoutlog] = edf2set(datapath,fullfile('**',sess{i},'edf'),'Rdataf','rawData','Pdataf','prepData','sess',sess{i});
 
    % uqsetoutlog = unique(setoutlog);
    % subtmp = {subinfo.(sess{i}).sub};
    % for j = 1:length(uqsetoutlog)
    %     subinfo.(sess{i})(cellfun(@(x) contains(uqsetoutlog{j},x), subtmp)).edf2set = uqsetoutlog(cellfun(@(x) contains(uqsetoutlog{j},x), subtmp));
    %     uqsetoutlog{cellfun(@(x) contains(uqsetoutlog{j},x), subtmp)} = '';
    % end
    % uqsetoutlog(cellfun(@isempty,uqsetoutlog)) = [];
    % for j = 1:length(uqsetoutlog)
    %     subinfo.(sess{i})(end+1).sub = sub{cellfun(@(x) contains(uqsetoutlog{j},x), subtmp)};
    %     subinfo.(sess{i})(end).edf2set = uqsetoutlog(j);
    % end
    % save("subinfo.mat","subinfo")
    % -------------------------------------------------------------------------
end