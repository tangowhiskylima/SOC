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

## Install Sysmon from sysinternals.

Open up a browser in your Win 10 VM and search for Sysmon.

<img width="1073" height="448" alt="image" src="https://github.com/user-attachments/assets/370a000b-ddfd-42c7-9a25-9a4e3a5b82b7" />

Go to Sysmon page and click on Download Sysmon

<img width="1575" height="575" alt="image" src="https://github.com/user-attachments/assets/99dcfc35-49bc-4e58-9868-18dbb2b15099" />

Unzip the Sysmon download and you should see these files.

<img width="1120" height="355" alt="image" src="https://github.com/user-attachments/assets/eb0e0436-c790-4b28-aefe-e975a38e4a45" />

Open up a Powershell prompt as admin and change to the folder of the downloaded files.

<img width="985" height="547" alt="image" src="https://github.com/user-attachments/assets/f2e04b12-48b4-470f-9053-71e31232d02d" />

Run the command ` .\Sysmon.exe -i -n -accepteula `. Once installation is complete, you would see the Sysmon started message.

<img width="657" height="385" alt="image" src="https://github.com/user-attachments/assets/47235112-6afd-4aad-a87c-69728675cef4" />

Test the Sysmon logging by creating a new user via the powershell prompt ` net user <username> <passwd> /add ` <br>
Open up Event Viewer, go to Applicataions and Services Logs > Microsoft > Windows > Sysmon > Operational <br>
Click the Find function at the right side of the screen and search for the username you have created. The log should display the event with the command you ran to create the user

<img width="2140" height="830" alt="image" src="https://github.com/user-attachments/assets/e6755f59-8897-4dbd-94b5-0657cb9e14f0" />

## Set up Elastic Agent for Windows Events

Log in to the Kibana Webpage and go to Management > Integrations. Search for Windows. <br>
We can select the non-custom Windows option for now then click Add Windows.

<img width="2343" height="714" alt="image" src="https://github.com/user-attachments/assets/34768053-df9a-469c-950d-2da0ff2eb4dc" />

You will see the Integration configuration page. Scroll down and review the events that will be collected. <br>
Ensure Sysmon Operational is enabled then click Save and Continue. Select Add Elastic Agent to your hosts.

<img width="1673" height="1170" alt="image" src="https://github.com/user-attachments/assets/66604d1f-dbd1-4966-9571-1fd5170d9207" />

Click Add Agent then Run Standalone. <br>
Select Create API Key and download the policy to your host machine. <br>
Scroll down to select Windows X86_64 for the installation instructions. <br>
Unzip the file once download is complete and drag and drop the downloaded policy from your host machine to the VM to replace the default copy.

<img width="1193" height="689" alt="image" src="https://github.com/user-attachments/assets/1fdbe51a-8786-4139-9d87-332f69d65d10" />

From the powershell prompt, cd into the unzipped folder and run ` .\elastic-agent.exe install `

<img width="956" height="487" alt="image" src="https://github.com/user-attachments/assets/78c4cf9b-6ff0-4270-b8ed-9053976df3a6" />

Test the log forwarding by opening Event Viewer and clear Windows Security Logs. <br>
Login to Kibana, under Discover, search for ` event.code: "1102" ` and it should show the security log cleared event details.

<img width="2542" height="1192" alt="image" src="https://github.com/user-attachments/assets/38b6f8b6-59e4-4643-a6cf-692b7765e007" />

This concludes the setup for Win 10 VM.
