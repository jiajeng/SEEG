- run [SEEGexp_checkfile.m](./code/SEEGexp_checkfile.m)

## input 
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
  
  
## output : 
![image](https://github.com/user-attachments/assets/a1b77b79-d003-4f62-9b84-0f4f6bbd77fb)


- set file (set) 
  讀檔案時會使用eeglab的讀檔方式，會把每個trigger的開始跟下降時間都標定出來(event table)
  但在跑整段實驗流程時切不同的Session去存檔案時，使用的就會是.set
  ###### 嘗試過轉成edf file  1. 用eeglab的函式，轉成edf再讀檔看到的訊號會變成鋸齒狀的  2. 用寫edf header跟signal的方式存檔，但沒辦法拿去eeglab裡讀。
  
- excel (checkfile.xlsx)  
  all : 所有的檔案整理成一個表格  
  主要看DurTrig(訊號得到的Trigger數量/持續時間)跟edatTrig(edat檔案裡讀出來的結果)。  
  ![image](https://github.com/user-attachments/assets/49b879b7-8251-4866-a88b-2403d5211e35)
  session : 每個檔案有自己的一個sheet，跟所有放一起的差異在多了每個Trigger的持續時間。
  
- Result logging (report.txt) : 輸出在過程中有問題的session紀錄
  1. 沒找到檔案   
     ![image](https://github.com/user-attachments/assets/bf118949-4aac-4688-95da-b099ec255f47)

  2. 訊號得到的Trigger跟edat得到的不一樣
     ![image](https://github.com/user-attachments/assets/fa584eae-60b7-42d8-874e-e7addaf2c45f)

  3. 沒有找到mapping file
     ![image](https://github.com/user-attachments/assets/82e6d095-9f60-49b2-89cf-4734f820b2d3)

- event channel plot : 標記有抓到的Trigger(紅色o : Trigger開始，藍色o : Trigger 結束)。
  ![image](https://github.com/user-attachments/assets/954e8fd9-9749-4bfa-a927-5acf8c2e2df5)

   
