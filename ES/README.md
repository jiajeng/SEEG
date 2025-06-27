![image](https://github.com/user-attachments/assets/40e3df22-62a5-4aca-9cab-6a3cc1294cc5)## document 

- `paper document in device suitcase` --  newer version --> suggest read this
    
- NAS : `/LabData/Cascade/Documents/` -- older version
    
# content 
- [device](#device)
    
- [connect two PCs using Ethernet](#ethernet)
  - [device](#devicerequire)
      
  - [cable connection](#cables)
      
  - [how to use](#method)
      
    - [Stim. PC](#stimpc)
        
    - [Exp. PC](#exppc)

- [cable connection for other method](./OtherMethod.md)
    - [stimulate first then give stimulus item](./OtherMethod.md/#in)
        
    - [Ideally--TriggerIn and TriggerOut](./OtherMethod.md/#orig)
        

## device
### base module  
 ![image](https://github.com/user-attachments/assets/c086aa11-c317-4148-a207-0d8b68855c9a)

### limb module  
![image](https://github.com/user-attachments/assets/af13575f-d1b9-4b26-a882-131293cf2e52)



### software(Cascade Surgical Studio)
[Quick Start Guide](./software/README.md)
  
> [!Note]
> 1. when using trigger-in to control stimulation and trigger-out, there has a random delay before stimulation(after trigger in).
> 2. about 20% trigger-out will be missing.(Obeserved from clicking stimulus button)

## <a name="ethernet"></a> connect two PCs using Ethernet (for solve trigger-in delay)

###### it seems to stimulate instantly when click stimulus button so ...  
*processs : using ethernet (most consistent latency, has minimal variance) send trigger to stim. pc then using python (pyautogui package) control cursor to click stim. button*
  
### <a name="devicerequire"></a> device :
  
- stim. PC
- exp. PC
- ES device
- Amplifier(EEG)

### <a name="cables"></a>cable connection
![image](https://github.com/user-attachments/assets/e409176f-7b65-4e60-9888-4e57be91a71b)

## <a name="method"></a> how to use
![image](https://github.com/user-attachments/assets/88d11e69-7e0e-48f2-85df-3b0e0c5df868)

## <a name="stimpc"></a>Stim. PC
### enviroment  
- python 3.10  
    - package : pyautogui

> [!Note]
> for MSI laptop, enviroment is set in anaconda.

### set host(elec. PC)
- open casade surgical studio
    - start a case
    - open Trigger OUT fold
- open anaconda prompt(nevigate to Eth_server.py folder)
- ![image](https://github.com/user-attachments/assets/44e00faa-8715-4a0a-8585-16aa347364cb)
- run Eth_server.py  
  ![image](https://github.com/user-attachments/assets/88f9e283-d14c-4a20-8a85-7b95bbf4976c)

### client

## [cable connection for other method](./OtherMethod.md)   
[stimulate first then give stimulus item](./OtherMethod.md/#in)        
[Ideally--TriggerIn and TriggerOut](./OtherMethod.md/#orig)  
