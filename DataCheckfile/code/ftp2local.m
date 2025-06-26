function [Subfolder] = ftp2local(ftpServer,folders,Fget,varargin)
% input  :  ftpServer, "struct" -- ip, nas ip
%                                  account, nas account                                
%                                  password, nas password
%                                  infolder, SEEG base folder
%                                  localfolder, get nas file to local path
%           folders, "cell" -- get folders that under subject folder, if
%                              want get all subfolder under subject folder
%                              input folders = {''}. Also can enter file to
%                              get certain file under subject folder
% option input : 
%           subject, "cell" -- subject id under Datapath, if no enter
%                              this input term, default is find all folders 
%                              that foldername length is 4 (for SEEG, if want 
%                              to use others need to change line 46 ~ 50 )


% set varargin
VARNM = varargin(1:2:end);
VARVR = varargin(2:2:end);
% set flags
subf = false;
for i = 1:length(VARNM)
    switch VARNM{i}
        case 'subject'
            if class(VARVR{i}) ~= "cell", error('input subject class is cell, enter class type is %s', class(VARVR{i})); end
            eval([VARNM{i},'=VARVR{i};']);
            subf = true;
        otherwise
            error('do not recognize input name "%s"', VARNM{i});
    end
end

% create sub log file(.mat struct)
if ~exist("log.mat",'file')
    % every sub has a table contains folder 
    log = struct();
else
    load("log.mat");
end


% get Server 
sftpServ = sftp(ftpServer.ip,ftpServer.account,"Password",ftpServer.password);

% cd to SEEG folder
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
            % find under Subject fileName
            cd(sftpServ,ftpServer.infolder);
            cd(sftpServ,subject{nsub});
            Subfolder = dir(sftpServ);
            Subfolder = fullfile({Subfolder.folder},{Subfolder.name})';
            cd(sftpServ,'/');
            cd(sftpServ,ftpServer.infolder);
            % get certain folder
            contxt = fullfile(subject{nsub},folders{ifd},'.');
            contxt(contxt=='\') = '/';
            if Fget
                mget(sftpServ,contxt,ftpServer.localfolder)
    
                log(end+1).func = 'ftp2local';
                log(end).sess = folders{ifd};
                log(end).sub = subject{nsub};
                log(end).('nasPath') = fullfile(ftpServer.infolder,subject{nsub},folders{ifd});
                log(end).('rawPath') = fullfile(ftpServer.localfolder,subject{nsub},folders{ifd});
                log(end).timestamp = string(datetime);
            else
                log(end+1).func = 'ftp2local';
                log(end).sess = folders{ifd};
                log(end).sub = subject{nsub};
                log(end).info = 'Check Folder Name';
                log(end).timestamp = string(datetime);
            end
        catch ME 
            if string(ME.message) == string(sprintf('File "%s/%s/." not found on server.',subject{nsub},folders{ifd}))
                sprintf('not find %s folder in %s',folders{ifd},subject{nsub})
                log(end+1).func = 'ftp2local';
                log(end).sess = folders{ifd};
                log(end).sub = subject{nsub};
                log(end).error = sprintf('not find %s folder in %s',folders{ifd},subject{nsub});
                log(end).timestamp = string(datetime);
            else
                close(sftpServ)
                rethrow(ME)
            end
        end
    end
end
close(sftpServ)
save("log.mat","log");

