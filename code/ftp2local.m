function ftp2local(ftpServer,folders,varargin)
% input  :  ftpServer, "struct" -- ip, nas ip
%                                  account, nas account                                
%                                  password, nas password
%                                  infolder, SEEG base folder
%                                  localfolder, get nas file to local path
%           folders, "cell" -- get folders that under subject folder, if
%                              want get all subfolder under subject folder
%                              then folders = {''}. Also can enter file to
%                              get certain file under subject folder
%  


% set varargin
VARNM = varargin(1:2:end);
VARVR = varargin(2:2:end);
% set flags
subf = false;
for i = 1:length(VARNM)
    switch VARNM{i}
        case 'subject'
            if class(VARVR{i}) ~= "cell", error('input subject class is cell, enter class type is %s', class(VARVR{i})); end
            eval([VARNM{i},'=VARVR{i}']);
            subf = true;
        otherwise
            error('do not recognize input name "%s"', VARNM{i});
    end
end

% create sub info file(.mat struct)
if ~exist("subinfo.mat",'file')
    % every sub has a table contains folder 
    subinfo = struct();
else
    load("subinfo.mat");
end


% get Server 
sftpServ = sftp(ftpServer.ip,ftpServer.account,"Password",ftpServer.password);
% cd to SEEG folder
cd(sftpServ,ftpServer.infolder);
if ~subf
    % get subject name
    subject = {dir(sftpServ).name};
    subject = subject(cellfun(@(x) length(x)==4, subject));
end
% update filemarker
% mget(sftpServ,"filemaker/",ftpServer.localfolder)
% get needed subfolder under subject path 
for nsub = 1:length(subject)
    for ifd = 1:length(folders)
        try
            contxt = fullfile(subject{nsub},folders{ifd},'.');
            contxt(contxt=='\') = '/';
            mget(sftpServ,contxt,ftpServer.localfolder)
            % find subject name if repeat then replace in this block
            if ~isempty(fieldnames(subinfo))
                tmp = string({subinfo.(folders{ifd}).sub});
            else
                tmp = "";
            end
            
            if any(tmp==string(subject{nsub}))
                subinfo.(folders{ifd})(tmp==subject{nsub}).sub = subject{nsub};
                subinfo.(folders{ifd})(tmp==subject{nsub}).('nas') = fullfile(ftpServer.infolder,subject{nsub},folders{ifd});
                subinfo.(folders{ifd})(tmp==subject{nsub}).('local') = fullfile(ftpServer.localfolder,subject{nsub},folders{ifd});
            else
                if isempty(contains(fieldnames(subinfo),folders{ifd})), subinfo.(folders{ifd}) = []; end
                if ~contains(fieldnames(subinfo),folders{ifd}), subinfo.(folders{ifd}) = []; end
                subinfo.(folders{ifd})(end+1).sub = subject{nsub};
                subinfo.(folders{ifd})(end).('nas') = fullfile(ftpServer.infolder,subject{nsub},folders{ifd});
                subinfo.(folders{ifd})(end).('local') = fullfile(ftpServer.localfolder,subject{nsub},folders{ifd});
            end
        catch ME 
            if string(ME.message) == string(sprintf('File "%s/%s/." not found on server.',subject{nsub},folders{ifd}))
                sprintf('no find %s folder in %s',folders{ifd},subject{nsub})
            else
                rethrow(ME)
            end
        end
    end
end
close(sftpServ)
save("subinfo.mat","subinfo");
