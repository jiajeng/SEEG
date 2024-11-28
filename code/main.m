datapath = 'E:\SEEG\Data';
sess = {'eeg_EOR'};

for i = 1:length(sess)
    % --------------convert .edf data to .set file-----------------------------
    [errorlog,setoutlog] = edf2set(datapath,fullfile('**',sess{i},'edf'),'Rdataf','rawData','Pdataf','prepData');
    % -------------------------------------------------------------------------
end