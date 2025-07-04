- run [SEEGexp_checkfile.m](./code/SEEGexp_checkfile.m)

- step 1 : 輸入存放資料的資料夾 `Enter subject datapath : `

- step 2 : 輸入受試者編號，如果有一個以上的受試者用空格分開 `Enter subject id : `

- step 3 : 選擇要使用哪一種方式  

  - <ins>method 0</ins> : 把資料切好分成n份，沒有放在每個session的資料夾中，需要整理(1hz跟50hz mapping的資料檔預期會跟EEG的資料放一起)。
      - step 1 : 分別輸入放edf/logging檔案的資料夾
  
  - <ins>method 1</ins> : 有整段的資料，需要把資料切成不同段 (切好分別放在各自的資料夾內，順序從logging file的時間先後去看)。
    - step1 : 輸入整段.edf的檔案跟loggingfile的路徑

    [例外狀況](./exception.md)

  - <ins>method -1</ins> : 資料都整理好了，只需要做檢驗資料的完整性。
    - step 1 : 輸入有哪些session，不用重複，輸入想要去檢驗trigger數量的sessions

  
- checkfile output :
  - 受試者資料夾底下有一個統整的excel表格
  - 每個session底下會多加一個checkfile的資料夾，裡面包含每個檔案裡訊號圖以及一個excel表格，比起統整的表格多了每個trigger持續的時間。


  
