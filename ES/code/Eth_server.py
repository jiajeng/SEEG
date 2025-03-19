# -*- coding: utf-8 -*-
"""
Created on Thu Dec 26 15:50:15 2024

@author: IOM
"""

import socket
import time
import pyautogui
import os

# check pos file exist
posfile = os.listdir('.')
nofile = True
# initial click position 
if 'stimButtom_pos.txt' in posfile:
    nofile = False
    posfile = open('stimButtom_pos.txt','r')
    pos = posfile.read()
    posfile.close()
    pos = pos.split('\n')
    x = int(pos[0])
    y = int(pos[1])
    

if nofile: 
    print('move cursor to the stimulus buttom then press enter')
    input('press enter to continue ...')
    print('3 ...')
    time.sleep(1)
    print('2 ...')
    time.sleep(1)
    print('1 ...')
    time.sleep(1)
    x,y = pyautogui.position()
    f = input('save position in a .txt file?(y/~)')
    if f=="y":
        with open('stimButtom_pos.txt','w') as file:
            file.write(str(x)+'\n')
            file.write(str(y))
w,h = pyautogui.size()
print(f'position is x:{x} and y:{y} (top left is [0,0], monitor size is {w}x{h} ) ')

# get IP name 
# Get the hostname of the local machine
hostname = socket.gethostname()

# Get the IP address associated with the hostname
ip_address = socket.gethostbyname(hostname)

print(f"Hostname: {hostname}")
print(f"IP Address: {ip_address}")



host = ip_address
port=1024
# Create a socket object
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the host and port
server_socket.bind((host, port))

# Start listening for connections
server_socket.listen(1)
print(f"Server listening on {host}:{port}")

# Accept a connection
conn, addr = server_socket.accept()
print(f"Connection established with {addr}")

# Receive data
t = []
while True:
    data = conn.recv(1024)  # Buffer size
    data = data.decode('utf-8')
    if data:
        t.append(time.time())
        print(f"{time.time()}")
        print(f"Received: {data}")
        
        # Send a response back
        conn.sendall(b"Data received")
        if data == "in":
            pyautogui.click(x,y)
        if data == "exit":
            break

# Close the connection
conn.close()
print("Connection closed")
os._exit(00)
