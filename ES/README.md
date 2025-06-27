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

- [cable connection for other method](./OtherMethod.md)
    - [stimulate first then give stimulus item](./OtherMethod.md/#in)
        
    - [Ideally--TriggerIn and TriggerOut](./OhterMethod.md/#orig)
        

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
## <a name="stimpc"></a>Stim. PC

- run [Eth_server.py](./code/Eth_server.py), need `pyautogui package` in python enviroment

### Step 1 : get click button position (if no button pisition .txt file)

- keep the mouse in stimulus button , use `alt+tab` or other shortcut method to command window then press enter

    ![image](https://github.com/user-attachments/assets/db6c4a4f-1af1-4368-aa98-c66d2636af03)
    ![image](https://github.com/user-attachments/assets/e5ecb0f0-3b5e-4376-8eb8-5636a7abfa0e)
    
- ask to save a .txt file that save position coordinate (suggest enter y, don't need to run this step again next time. )
    
    ![image 1](https://github.com/user-attachments/assets/0356f45b-1f30-465f-bd6a-60ba13e9ffd0)
    
> [!Note]
> when start run experiment, make sure the `stimulus button position is not moved`

### step2 : use this PC IP to setup a server (automatically)
- Host Server
  ![image](https://github.com/user-attachments/assets/e1ea0a66-04f1-490b-ae2a-fa333f85bef5)
  
## <a name="exppc"></a>Exp. PC

### step 1 : get stim.PC IP address and Port (define in the code line 58, typically lager than 1024)

- check stim. pc ip address and Port that will shown in command line if run Eth_Server.py file
  
  ![image](https://github.com/user-attachments/assets/247743cf-36d8-41ad-ae2a-693829c5d552)

### step 2 : Add socket device in eprime

- add a scocket device in eprime and enter IP address and Port

    ![image](https://github.com/user-attachments/assets/3c3d3e1c-d32d-4dba-a1e3-754e06f7b3c7)

### step 3 : use socket to send trigger

- send ES trigger by socket device
    ![image](https://github.com/user-attachments/assets/99c8509c-c72b-479d-be0a-a130941b0107)

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
![image](https://github.com/user-attachments/assets/6991b158-b623-418d-bdde-4945fb2e254c)

## <a name="orig"></a> using Trigger in to control stimulus
###### ideally ...

*Process : send trigger to stimulator then do the electrical stimulation and send a trigger-out ...*

### cable connection
![image](https://github.com/user-attachments/assets/42b2af7b-92f8-4dce-93e2-e78de69e9a9e)

> [!Note]
> if `trigger-in delay` solved 

