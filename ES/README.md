## document 

- `paper document in device suitcase` --  newer version --> suggest read this
    
- NAS : `/LabData/Cascade/Documents/` -- older version
    
# content 
- [device](#device)
    
- [connect two PCs using Ethernet](#ethernet)
  - [device](#devicerequire)
      
  - [flow chart](#flowchart)
      
  - [how to use](#method)
      
    - [Stim. PC](#stimpc)
        
    - [Exp. PC](#exppc)

- [cable connection for other method](#othmcw)
    - [stimulate first then give stimulus item](#in)
        
    - [Ideally--TriggerIn and TriggerOut](#orig)
        

## device
### base module  
  ![image](https://github.com/user-attachments/assets/66fb2772-f642-4b06-81d3-0b5a7b651eec)

### limb module  
  ![image](https://github.com/user-attachments/assets/8e9ba2d6-25fa-47cd-ad8a-cb900f7c82cc)

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

### cable connection
![image](https://github.com/user-attachments/assets/bf212b03-ded7-47e4-a5b3-e0307fba5db2)
### <a name="flowchart"></a>flow chart
![image](https://github.com/user-attachments/assets/f0fdc0e4-d16f-47b4-a98f-391a94d3968c)

## <a name="method"></a> how to use
## <a name="stimpc"></a>Stim. PC

- run [Eth_server.py](./code/Eth_server.py), need `pyautogui package` in python enviroment

### Step 1 : get click button position (if no button pisition .txt file)

- keep the mouse in stimulus button , use `alt+tab` or other shortcut method to command window then press enter

    ![image](https://github.com/user-attachments/assets/ba39972f-9fb8-4548-9691-a34183060c0b)
    ![image](https://github.com/user-attachments/assets/53c48264-fdf0-46c6-9f41-8165e6911557)
    
- ask to save a .txt file that save position coordinate (suggest enter y, don't need to run this step again next time. )
    
    ![image 1](https://github.com/user-attachments/assets/0356f45b-1f30-465f-bd6a-60ba13e9ffd0)
    
> [!Note]
> when start run experiment, make sure `cascade surgical studio page at the top` and the `stimulus button position is not moved`

### step2 : use this PC IP to setup a server (automatically)
- Host Server
    
   ![image 2](https://github.com/user-attachments/assets/d27482fb-ae40-4d7f-9dbe-8afec4b1f9d8)

## <a name="exppc"></a>Exp. PC

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
> string : "in" --> tell host click button `add in trigger-out`   
> string : "exit" --> tell host close server `add in last slice`    
> can change in host server code(Eth_Server.py) line 85,87


# <a name="othmcw"></a> Other method how to connect cable
## <a name="in"></a>  Behavioral stimulation first then give electrical stimulation
###### because the trigger-in random delay so behavioral stimulation first then give electrical stimulation item will discard the random delay ... 
*Exp. process :*   
*1. start to send a trigger to stimulator*  
*2. Wait for trigger out*  
*3. give stimulus item*  
*4. send trigger to stimulator and Amp.*  
*loop 2.-4. to the end ...*

### cable connection
![image](https://github.com/user-attachments/assets/a9e52d04-c9e1-44b2-8e90-637928df0c31)


## <a name="orig"></a> using Trigger in to control stimulus
###### ideally ...

*Process : send trigger to stimulator then do the electrical stimulation and send a trigger-out ...*

### cable connection
![image](https://github.com/user-attachments/assets/95e48a72-b5de-4de9-a460-68ed0f57f69c)

> [!Note]
> if `trigger-in delay` solved 

