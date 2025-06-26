# 
  
- aim : 檢查資料有沒有問題。

- method 1 : 把資料切好分成n份，放在edf跟logging的資料夾內，包含1hz跟50hz mapping的資料檔。
  
  - step 1 : 把每個session的資料分成不同的資料夾放好(eeg_PN,eeg_EOR,eeg_ECR,...)，包含edf檔案跟logging檔案。 `main2.m line 105~110`
  - step 2 : 檢查Dummy trigger有沒有符合預期(5 or 10)。 `main2.m line 113, checktrials.m line 113~256`
  - step 3 : 檢查trigger有幾個跟duration跟logging file的資料。 `main2.m line 113, checktrials.m line 261~281`
  - step 4 : 
