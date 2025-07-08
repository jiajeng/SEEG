- run [SEEGexp_checkfile.m](./code/SEEGexp_checkfile.m)

- step 1 : 輸入必要資訊
  ![image](https://github.com/user-attachments/assets/24b68206-a421-4856-af5f-d99efc55bb74)
- step 2 : 選擇要做的程序
  -  method 0 : 把資料切成每個session，沒放在每個session的資料夾中，需要整理。
     ###### 1hz跟50hz mapping的檔案預期會跟edf的資料放一起  
     選擇edf/logging的資料夾(預期所有session edf/logging的資料都在同一個資料夾底下)
    
  -  method 1 : 有整段實驗的資料，需要把資料切成每個session的片段。用logging file最後修改時間來找實驗順序。  
     ###### 1hz跟50hz mapping的檔案預期會跟edf的資料放一起   
     選擇整段的edf file跟logging的資料夾  
     檢測logging file 的時間順序來得到每個session的排序。  
      > [Note]  
      > 如果檢測到logging file的數量跟訊號切出來session的數量不一致，會讓使用者確認  
      > ![image](https://github.com/user-attachments/assets/ff4e604b-4b70-4d6f-afe2-eaa593632cc7)  
      > 1. 檢查logging file數量  
      > 2. 檢查訊號取session有沒有抓錯(會跳出一張event channel的圖，標出開始跟結束的點) --> 這個有問題的話應該是event channel原始訊號有什麼問題導致抓錯  
      > y : 去檢查logging file，補好之後，輸入y，沒補好會出不去。  
      > n : 不管logging file，先輸入n，然後輸入實驗流程的所有session，預計會跟訊號切出來的session數一樣。  
      ![image](https://github.com/user-attachments/assets/0cfef9f1-114f-4e2c-b974-32763698128b)



  - method -1 : 不對資料做其他事情，直接檢驗資料的完整性  
    輸入要檢驗的session名稱。(不分大小寫，用空格分開)  
      ![image](https://github.com/user-attachments/assets/28085577-50b5-4e18-ac94-b19049999968)


  
