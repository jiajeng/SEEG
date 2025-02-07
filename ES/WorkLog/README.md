## content
[2024/12/20 -- 跟廠商測試](#241220)  
[2024/12/23 -- idea](#241223)  
[2024/12/25 -- test for two PCs send trigger](#241225)   
[2024/12/26 -- bluetooth not work](#241226)    
[2024/12/27 -- ethernet cable is best but laptop no ethernet slot to insert, ES out(12) to Eprime then ...](#241227)  
[2025/01/06 -- try ethernet cable on EMG data collection --> latency 0.3~0.4s](#250106)    
[2025/01/08 -- try direct ethernet connect to two PCs --> latency 190ms but stable, if minus mean latency max latency is 17ms](#250108)    

## 241220
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
  
- 測試1 : trigger in跟trigger out 都會好好的運作    
`用eprime送value 5出去(pin2  1, pin4  4)`  
`刺激器收到 pin2 的上升波 開始制動`  
&ensp; - 刺激器 ：   
&ensp; `發送刺激 等300ms 發送trigger out (pin4  4)`
- 結果1 ： 用新線測試(trigger in pin2  trigger out pin4)   
&ensp; `trigger in eeg 可以收到數值  trigger out 收不到`  `可能是資料腳還是在input所以無法？eprime那端擋掉的？`   
- 結果2 : 新線是trigger in，用一個bnc pin 4接trigger out 
`trigger in 可以看到 1或5看eprime設定多少(但1應該就行`  
`trigger out 也可以看到 16，但in的值要歸0，不然會是in的值 `     
 

- 測試2 : 刺激器的out送到eprime，eprime在輸出圖片之類的東西     
`嘗試直接接pin12到trigger out送給eprime`-->`結果 : 沒有反應，在想是不是epime那邊的data什麼的?好像可以改平行埠要in還是out可能要改成out，再試試`  

 
- 結果 ：   
`trigger out 有時候會漏送，即便是沒有input的時候`  
`應該是刺激器那邊的input有問題 --> 如果不使用input作為輸入的話，用點的送刺激出去的話，trigger就不會延誤了，點下去的瞬間會給電跟trigger`   
`新線材沒問題，但不能同時當作trigger in 跟 out,感覺要設定資料型態是in 還是out`  

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

## 241223
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- for see trigger in and out value in EEG recorder  
![image](https://github.com/user-attachments/assets/1bc306a4-bf8d-42f6-82e8-75f984e5315e)
if this is feasible then it should used for `electrode stimulation` --> `expriment stimulation`
> [!Note]
> remember to set 0 to data pin, otherwise data pin will stuck in some value
> e.x. if input value is 5, then no set value to 0, output value will be 5 add output value

- for input delay
using exp.PC send trigger to sti.PC then control mouse to click stimulus buttom  

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 241225
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
comunicate exp.PC and stim.PC using bluetooth    
- exp. PC client(send trigger)    
  - package 1 : psycopy  
  install(for anaconda virtual enviroment) : 1. `clone this git repo : https://github.com/psychopy/psychopy)`(use git clone or just download git just get psychopy folder)    
  &ensp;&ensp;&ensp;&ensp; 2. open command and cd to psychopy dir `cd C:\Users\hp\Documents\Git_repo\psychopy`   
  &ensp;&ensp;&ensp;&ensp; 3. enter `pip install -e .`
  - package 2 : pybluez  
  install : 1. `clone this git repo : https://github.com/pybluez/pybluez.git`  
  &ensp;&ensp;&ensp;&ensp; 2. open your enviroment prompt or cmd cd to pybluez dir  
  &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`cd C:\Users\hp\Dowloads\pybluez-master`  
  &ensp;&ensp;&ensp;&ensp; 3. enter `python setup.py install`  
    
- stim. PC Server
  - package 1 : pybluez
  - package 2 : pyautogui
  install(for anaconda virtual enviroment) : `conda install conda-forge::pyautogui`  
  &ensp;&ensp;&ensp;&ensp; (for base enviroment) : `pip install pyautogui`   

 
- exp. PC [solve](https://discourse.psychopy.org/t/problem-with-psychopy-parallel/8857/5)  
using psycopy `parallel.PrallelPort(address)` will output a nonetype variable means can't read data in parallel port. So follow this post to solve. download `InpOutx64.dll` copy to ./windows/System32 then it should be good to run.  

- conclusion
    - connect two pcs using bluetooth
    - stim. PC is server to receive data
    - exp. PC is client to send data to stim. pc
    - exp. PC read parallel port data to get eprime event


&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 241226
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- test for bluetooth    
latency too much > 1ms 
- try ethernet cable   
for now use wifi find network socket for laptop  
 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 241227
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- test for ethernet cable  
- only send and receive latancy = 0.001s  
but laptop has no ethernet slot. for now ethernet cable has best lantency.

- test for ES trigger out(12) to e-prime then do some stimulus(2 or 4). can work.

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 250106
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
##### comunicate exp.PC and stim.PC using ethernet cable   
- exp. PC(send trigger, client)
  - E-prime device socket
- stim. PC(receive trigger, Server)
  - package socket(no need to install)
  - check IP in this PC

- result
  - e-prime send event from socket to ES laptop(python receive socket event then using pyautogui click stimulus buttom)    
  - try stimulus interval 1000ms, 2500ms, 1500ms --> result : maximum latancy point are 300-400(around 0.3~0.4s)
  
  - but latancy is 0.001s when only using python to test send and receive event using socket 
  - maybe ....
  - e-prime send event has latancy(try using LPT to send event in e-prime, and using python to read LPT data then send event to ES laptop)(env ==> BTClient(psycopy))
  - ES software has latency(using python or something IDL to send a TTL signal to trigger in, maybe is all e-primes latency??)

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 240108
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- using a laptop that contains ethernet slot
- try not to use Aㄎ&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 241226
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- test for bluetooth    
latency too much > 1ms 
- try ethernet cable   
for now use wifi find network socket for laptop  
 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 241227
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- test for ethernet cable  
- only send and receive latancy = 0.001s  
but laptop has no ethernet slot. for now ethernet cable has best lantency.

- test for ES trigger out(12) to e-prime then do some stimulus(2 or 4). can work.

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 250106
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
##### comunicate exp.PC and stim.PC using ethernet cable   
- exp. PC(send trigger, client)
  - E-prime device socket
- stim. PC(receive trigger, Server)
  - package socket(no need to install)
  - check IP in this PC

- result
  - e-prime send event from socket to ES laptop(python receive socket event then using pyautogui click stimulus buttom)    
  - try stimulus interval 1000ms, 2500ms, 1500ms --> result : maximum latancy point are 300-400(around 0.3~0.4s)
  
  - but latancy is 0.001s when only using python to test send and receive event using socket 
  - maybe ....
  - e-prime send event has latancy(try using LPT to send event in e-prime, and using python to read LPT data then send event to ES laptop)(env ==> BTClient(psycopy))
  - ES software has latency(using python or something IDL to send a TTL signal to trigger in, maybe is all e-primes latency??)

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 250108
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- using a laptop that contains ethernet slot.(MSI)
- try not to use Adaptor to connect two PCs.

- result
  - e-prime send event from socket to ES laptop(python receive socket event then using pyautogui click stimulus buttom)
  - simulus interval is 1500ms
  - --> the first few trial has most latency and become stable after few trial
  - --> mean latency is 172.6 ms but std is 14ms  
![image](https://github.com/user-attachments/assets/8ad3f639-c478-462b-9627-e7495969693f)

- conclusion
  - it has a certain latency exist exclude this the maximum latency is 17ms.

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- 星期一(2/10)約10 a.m.測試SEEG的器材，不用廠商硬體送trigger的方式，用電腦控制點放電的按鍵

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 
