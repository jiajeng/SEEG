## document 

- `paper document in device suitcase`
    
- `120.126.102.101(Nas) /LabData/Cascade/Documents/`
    
## content 
- [device connect](#deviceconnect)
    
- [connect two PCs using Ethernet](#Eth)
  - [device](#devicerequire)
      
  - [flow chart](#flowchart)
      
  - [how to use](#method)
      
    - [Stim. PC](#stimpc)
        
    - [Exp. PC](#exppc)


## <<a name="deviceconnect">> device
#### host module  
  ![image](https://github.com/user-attachments/assets/a9381689-0d91-460f-9a1f-2d534ca057c0)

#### limb module  
  ![image](https://github.com/user-attachments/assets/7b26b7f8-87a0-4349-bb43-0c9f22bd4e33)

#### connect 
- connect host and limb module, host module connect to stim. PC
  ![image](https://github.com/user-attachments/assets/885de71c-54c1-4682-a539-aff8252b9265)
- host module need power supply  
- electrode plug in limb module  
  ![image](https://github.com/user-attachments/assets/e5902e8e-35da-417a-afbd-54f39a423014)

## <<a name="Eth"></a>>connect two PCs using Ethernet
### <<a name="devicerequire"></a>> device :
  
- stim. PC
- exp. PC
- ES device
- Amplifier(EEG)
   
###  <<a name="flowchart"></a>>flow chart
![image](https://github.com/user-attachments/assets/f0fdc0e4-d16f-47b4-a98f-391a94d3968c)

## <<a name="method"></a>> how to use

after connect all cables

## <<a name="stimpc"></a>>Stim. PC

- run [Eth_server.py](./code/Eth_server.py), need `pyautogui package` in python enviroment

### Step 1 : get click button position (if no button pisition .txt file)

- move cursur to stimulus button then do not move, use `alt+tab` or other shortcut method to command window then press enter

    ![image](https://github.com/user-attachments/assets/759406a8-7af6-40d8-abe3-bc00da58c2f9)
    ![image](https://github.com/user-attachments/assets/53c48264-fdf0-46c6-9f41-8165e6911557)
    
- ask to save a.txt file to save position coordinate file (suggest enter y, for next time don’t need run this step again)
    
    ![image 1](https://github.com/user-attachments/assets/0356f45b-1f30-465f-bd6a-60ba13e9ffd0)
    

### step2 : use this PC IP to setup a server (automatically)
- Host Server
    
   ![image 2](https://github.com/user-attachments/assets/d27482fb-ae40-4d7f-9dbe-8afec4b1f9d8)

## <<a name="exppc"></a>>Exp. PC

### step 1 : get stim.PC IP address and Port (define in the code line 58, typically lager than 1024)

- check stim. pc ip address and Port that will shown in command line if run Eth_Server.py file
    
    ![image 3](https://github.com/user-attachments/assets/e3714073-46a4-44f7-9d6d-fbc27595ae88)
    

### step 2 : Add socket device in eprime

- add a scocket device in eprime and enter IP address and Port
    
    ![image 4](https://github.com/user-attachments/assets/cca9d6ab-40d0-471e-96b7-38bc79597890)
    

### step 3 : use socket to send trigger

- send ES trigger by socket device
    
    ![image 5](https://github.com/user-attachments/assets/d3250e38-2df0-45af-95be-c6a868955d83)
> [!Note]
> string : "in" --> tell host click button `add in trigger out`   
> string : "exit" --> tell host close server `add in last slice`    
> can change in host server code(Eth_Server.py) line 85,87  
