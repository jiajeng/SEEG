## document 

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

- [cable connection for other method](#otmec)
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
![image](https://github.com/user-attachments/assets/7cb1f368-7736-4e40-9c1a-1d487c14e6f7)

## <a name="method"></a> how to use
![image](https://github.com/user-attachments/assets/d3064d39-82f5-45a6-ac98-9b5ef9ec2f41)

## <a name="stimpc"></a>Elec. PC (Host)
### enviroment  
- python 3.10  
    - package : pyautogui

> [!Note]
> for MSI laptop, enviroment is set in anaconda.

- open casade surgical studio
    - start a case
    - open Trigger OUT fold  
![image](https://github.com/user-attachments/assets/40e3df22-62a5-4aca-9cab-6a3cc1294cc5)
- open anaconda prompt(nevigate to Eth_server.py folder)    
- run [Eth_server.py](./code/)    
  ![image](https://github.com/user-attachments/assets/88f9e283-d14c-4a20-8a85-7b95bbf4976c)

## <a name="exppc"></a>e-prime PC (Client)
- [template file (Ethtest.es3)](./code/)
- run e-prime after host is ready. (Eth_server.py is running)
- device : add socket   
  ![image](https://github.com/user-attachments/assets/fccb7a74-dbc5-4330-a32b-850ceda71a4b)
  - read ip and port from anoconda prompt   
  ![image](https://github.com/user-attachments/assets/b173f718-af04-46ce-a195-f7876f84320b)

- send trigger   
  ![image](https://github.com/user-attachments/assets/0e1dead9-2a96-49db-9750-39c6ec855309)

  
## <a name="otmec"></a> [cable connection for other method](./OtherMethod.md)   
[stimulate first then give stimulus item](./OtherMethod.md/#in)        
[Ideally--TriggerIn and TriggerOut](./OtherMethod.md/#orig)  
