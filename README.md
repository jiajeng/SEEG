# SEEG
#### Data
```
Nas
ip : 140.119.165.35 
account : nlabuser01 
password : nissen6034 
```
`SEEG data folder : /space/maki7/nissen_eegmri/tasked_seeg`

#### 1128
- add edf2set file
- input : datapath dir
- output : .set file   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;- default output to `edf file path`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;- if Rdataf and Pdataf optional input `Rdataf = 'rawData'`     
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  then .. output to prepdata folder with same subfolder in edffile path  `Pdataf = 'prepData'`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`e.x. edf file in 'E:\SEEG\Data\rawData\s021\eeg_EOR\edf'`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`then out file in 'E:\SEEG\Data\prepData\s021\eeg_EOR\edf'`   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; - if optional outpath is entered   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;   then output file will in outpath `outpath = 'E:\SEEG\Data\prepData'`


