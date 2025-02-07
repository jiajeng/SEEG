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
- exp. PC
  - check Stim. PC IP address that will show in command line if run Eth_Server.py file
  - add a socket device in eprime enter IP address
  - send ES trigger by socket device
