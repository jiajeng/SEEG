# SEEG
#### Data
```
Nas
ip : 140.119.165.35 
account : nlabuser01 
password : nissen6034 
```
`SEEG data folder : /space/maki7/nissen_eegmri/tasked_seeg`

#### 241128
- add edf2set file
- input : datapath dir
- output : .set file   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;- default output to `edf file path`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;- if Rdataf and Pdataf optional input `Rdataf = 'rawData'`     
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  then .. output to prepdata folder with same subfolder in edffile path  `Pdataf = 'prepData'`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`e.x. edf file in 'E:\SEEG\Data\rawData\s021\eeg_EOR\edf'`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`then out file in 'E:\SEEG\Data\prepData\s021\eeg_EOR\edf'`   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; - if optional outpath is entered   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;   then output file will in outpath `outpath = 'E:\SEEG\Data\prepData'`


#### 241202
- add ftp2local file
- input : ftpServer struct with fieldnames `ftpServer.ip`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;
&ensp;&ensp;&ensp;&ensp;&ensp;`account`   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;
&ensp;&ensp;&ensp;&ensp;&ensp;`password`   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;
&ensp;&ensp;&ensp;&ensp;&ensp;`infolder`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;
&ensp;&ensp;&ensp;&ensp;&ensp;`localfolder`
- output : `download folder`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;add a `info.mat` file in code path

`create a info.mat file to store all process steps and paths`
