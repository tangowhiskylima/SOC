# Setup Win 10 VM in LAN segment with elastic-agent to send Windows Event Logs

Login to the Win10 VM with the credentials created during installation. <br>
Right click network connections on the bottom right of the taskbar and click on Open Network & Internet Settings. <br>

<img width="2547" height="1357" alt="image" src="https://github.com/user-attachments/assets/bf12304f-622b-4f11-b86f-9410d7c5a056" />

Under Advanced network settings, click on Change adapter options. 

<img width="1329" height="991" alt="image" src="https://github.com/user-attachments/assets/88c45b3e-785b-4e25-a0e6-bedaa2f9a77e" />

Right click on Ethernet0 and click on properties.

<img width="596" height="404" alt="image" src="https://github.com/user-attachments/assets/82a9e28e-6477-4e46-800f-06ff8410da52" />

Click on Internet Protocol Version 4 (TCP/IPv4) then click on Properties.

<img width="713" height="617" alt="image" src="https://github.com/user-attachments/assets/4dae7655-b928-4222-afca-f67bf156e363" />

Select 'Use the following IP Address'

Enter a desired IP Address within the LAN address space. Subnet mask will be 255.255.255.0 and the default gateway and DNS server will be 172.16.50.1 which points to the interface address of pfSense LAN interface. Click OK

<img width="476" height="504" alt="image" src="https://github.com/user-attachments/assets/4034fc7d-da8c-4eff-9d89-9ef6214d60a5" />

Test if the network configuration works by accessing the Kibana webpage of ELK VM using the LAN address. If successful, you should be directed to the elastic login page. <br>

