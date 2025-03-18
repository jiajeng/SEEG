## Ethernet connect two PCs
- device :
  - stim. PC
  - exp. PC
  - ES device
  - Amplifier(EEG)
- flow chart
![image](https://github.com/user-attachments/assets/f0fdc0e4-d16f-47b4-a98f-391a94d3968c)

# how to use

after connect all cables

## Stim. PC

- run this .pyfile, need pyautogui package in python enviroment

### Step 1 : get click button position (if no button pisition .txt file)

- move cursur to stimulus buttomn then do not move, use alt+tab or other shortcut method to command window then press enter
    
    ![image](https://github.com/user-attachments/assets/53c48264-fdf0-46c6-9f41-8165e6911557)
    
- ask to save a.txt file to save position coordinate file (suggest enter y, for next time don’t need ru n this step again)
    
    ![image 1](https://github.com/user-attachments/assets/0356f45b-1f30-465f-bd6a-60ba13e9ffd0)
    

### step2 : use this PC IP to setup a server (automatically)
- Host Server
    
   ![image 2](https://github.com/user-attachments/assets/d27482fb-ae40-4d7f-9dbe-8afec4b1f9d8)

## Exp. PC

### step 1 : get stim.PC IP address and Port (define in the code, typically above 1024)

- check stim. pc ip address and Port that will shown in command line if run Eth_Server.py file
    
    ![image 3](https://github.com/user-attachments/assets/e3714073-46a4-44f7-9d6d-fbc27595ae88)
    

### step 2 : Add socket device in eprime

- add a scocket device in eprime and enter IP address and Port
    
    ![image 4](https://github.com/user-attachments/assets/cca9d6ab-40d0-471e-96b7-38bc79597890)
    

### step 3 : use socket to send trigger

- send ES trigger by socket device
    
    ![image 5](https://github.com/user-attachments/assets/d3250e38-2df0-45af-95be-c6a868955d83)
