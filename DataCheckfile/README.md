# 

- run [SEEGexp_checkfile.m](./code/SEEGexp_checkfile.m)

- step 1 : 輸入存放資料的資料夾 `Enter subject datapath : `
  ![image](https://github.com/user-attachments/assets/f6b9999c-7079-4255-a2de-ca1d72a03d47)

- step 2 : 輸入受試者編號，如果有一個以上的受試者用空格分開 `Enter subject id : `

- step 3 : 選擇要使用哪一種方式  
  ![image](https://github.com/user-attachments/assets/15461c3a-c4bb-4dd6-b0ee-c33b9c646387)

  - [method 0](./method0.md) : 把資料切好分成n份，沒有放在每個session的資料夾中，需要整理(1hz跟50hz mapping的資料檔預期會跟EEG的資料放一起)。
    
  - [method 1](./method1.md) : 有整段的資料，需要把資料切成不同段 (切好分別放在各自的資料夾內，順序從logging file的時間先後去看)。
 
  - [method -1](./method2.md) : 資料都整理好了，只需要做檢驗資料的完整性。
  
