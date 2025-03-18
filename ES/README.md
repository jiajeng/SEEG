## Ethernet connect two PCs
- device :
  - stim. PC
  - exp. PC
  - ES device
  - Amplifier(EEG)
- flow chart
![image](https://github.com/user-attachments/assets/f0fdc0e4-d16f-47b4-a98f-391a94d3968c)

## how to use
- after connect all cables
### Stim. PC
  - run [this .py file](./code/Eth_Server.py), need pyautogui package in python enviroment
  #### step 1 : get click button position (if no buttom position .txt file)
  - move cursur to stimulus buttom then do not move, use `alt+tab` or other sortcut method to command window then press enter  
  ![image](https://github.com/user-attachments/assets/7faf5cb8-6ada-4d85-ac90-1f5dd9feb2df)
  - ask to save a .txt file to save position coordinate (suggest enter y, for next time don't need run this again)  
  ![image](https://github.com/user-attachments/assets/e98908f6-6cd5-4cfd-a50b-164ab86228a3)
  #### step 2 : use this PC IP to setup a server (automatically)
   ![image](https://github.com/user-attachments/assets/f668ee34-3dba-4de6-9c4d-b2a5d161b4c4)


### exp. PC
  #### step 1 : get stim. PC IP address
  - check Stim. PC IP address that will show in command line if run Eth_Server.py file  
  ![image](https://github.com/user-attachments/assets/00d79718-c9ec-4f7e-9475-9d5de7725449)
  #### step 2 : Add socket device in eprime
  - add a socket device in eprime enter IP address  
  ![image](https://github.com/user-attachments/assets/012dc2c5-f9ca-413d-ac7f-13cd38ac8bc6)
  #### step 3 : use socket to send trigger
  - send ES trigger by socket device  
  ![image](https://github.com/user-attachments/assets/83401159-a223-4a9b-bc75-a69baf40c05c)

