# method 1 
- step 1 : 選取整段實驗的資料  
  ![image](https://github.com/user-attachments/assets/4585189a-536a-4abc-98f1-158bff3d76e5)
- step 2 : 選取存放所有實驗的logging file的資料夾  
  ![image](https://github.com/user-attachments/assets/df824183-0122-4920-81bf-74b5910b4739)
  
> [!Note]  
> 開始讀檔案，以我自己這邊的電腦讀整段的檔案大概需要2~3分鐘

- output : 創建所有session的資料夾，會step1的資料夾內找mapping 1hz跟50hz的資料，有就移到各自的資料夾。
 ![image](https://github.com/user-attachments/assets/737b6ea5-8d1f-462d-a8a5-4f442871c6fd)




      
## trouble shooting
- 如果抓出來的每段資料跟logging file的個數不一樣會出現這樣的訊息  
  ![image](https://github.com/user-attachments/assets/59932d7c-745e-4fd3-b586-a88a1ab9145e)
  
- 請先去檢查logging file是不是少抓幾個session的資料，再來檢查看看event的數值是不是對的(應該會跳出一張圖)。
  ![image](https://github.com/user-attachments/assets/49d56f08-7b5d-4269-8432-8abc64d51cfc)
  - 如果是抓錯的話，要改抓開始跟結束的演算法
  - [流程圖](./flowchart/splitfile.md)
    
- step 4 : 如果不想管logging file的個數的話，輸入`n`，然後輸入整個實驗流程是什麼`eor,ecr,music,...,ecr,eor`，用逗號分開，所有的session都要輸入，music跑6次就要輸入6次，跟實驗填的紀錄表一樣。
  ![image](https://github.com/user-attachments/assets/42839131-6e2e-472e-bcf5-a378aa548fc4)

