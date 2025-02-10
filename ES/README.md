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
- Stim. PC
  - run (this .py file)[./code/Eth_Server.py] (python enviroment need pyautogui package)
  - step 1(if no buttom position .txt file)
  - move cursur to stimulus buttom then do not move, use alt+tab or other sortcut method to command window then press enter
  - ask to save a .txt file to save position coordinate or not 
  - ![image](https://github.com/user-attachments/assets/e98908f6-6cd5-4cfd-a50b-164ab86228a3)
  - step 2 use this PC IP to setup a server
  - ![image](https://github.com/user-attachments/assets/f668ee34-3dba-4de6-9c4d-b2a5d161b4c4)


- exp. PC
  - check Stim. PC IP address that will show in command line if run Eth_Server.py file
  - ![image](https://github.com/user-attachments/assets/00d79718-c9ec-4f7e-9475-9d5de7725449)
  - add a socket device in eprime enter IP address
  - send ES trigger by socket device
