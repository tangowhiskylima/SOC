A home lab that simulates a network of DMZ, WAN and LAN. DMZ contains a Cowrie Honeypot, LAN consists of an ELK stack within an Ubuntu 22.04 VM with a Win10 VM. WAN will be simulated via the host machine and running a pfSense firewall VM to simulate the necessary network segmentation. This project runs multiple VMs at the same time so it is recommended to have at least 24GB to 32GB of RAM for smooth operations. 

# Updates in progress

## Setting up

1. [Setting up pfSense](/Install-pfSense.md)
2. [Install ELK](/Install-ELK.md)
3. Create another Ubuntu VM and [Install Cowrie](https://docs.cowrie.org/en/latest/INSTALL.html). Put the VM in the DMZ segment and create the netplan yaml file accordingly to assign a static IP Address.
4. [Setup Win10 VM](/Install-Win10VM.md) under LAN segment with elastic-agent to send Windows Event Logs
5. [Install Filebeat](/Install-Filebeat.md)
6. [Configure ELK](/Config-ELK.md)
7. [Install Elastic-agent](/Install-Elastic-agent.md) on ELK to receive pfSense logs


## Navigating ELK

<br>To view events that were forwarded by Beats and pfSense, login to the Kibana webpage, under the menu, select Discover.

<img width="2552" height="486" alt="image" src="https://github.com/user-attachments/assets/c1757bda-770a-4e53-a05b-b34430f773d6" />

<br>We can control the time frame we wish to see events for by selecting the appropriate time frame on the right.

<img width="2550" height="484" alt="image" src="https://github.com/user-attachments/assets/a3d629b4-2d2e-406e-a97a-0cbaa9064b4b" />

<br>On the left hand side, we are able to create different data views to view different logs. For instance, selecting pfsense will only display pfsense logs. This allows us to limit the scope of the logs to search.

<img width="1126" height="527" alt="image" src="https://github.com/user-attachments/assets/9a35b07c-69d3-461c-9ff4-7cdeba7047eb" />

<br>For instance, in our earlier configuration, Cowrie logs were indexed as project-logs. The data view can be limited to the particular index to show only logs from Cowrie.

<img width="2554" height="778" alt="image" src="https://github.com/user-attachments/assets/56d455ca-b220-4f73-b582-e2b737043c56" />

<br>Once you select the created data view, the events will be limited to only Cowrie related events, allowing you to focus your search.

<img width="2547" height="1272" alt="image" src="https://github.com/user-attachments/assets/35d06f81-08e3-449a-bb67-c2bccda53412" />

<br>Searching for failed login attempts.

<img width="2547" height="1272" alt="image" src="https://github.com/user-attachments/assets/2878de2b-3b18-435f-9ed0-5a562ccd145f" />

<br>Let's search for failed windows login by using Windows Security Event Code 4625.
<br>Type in ` event.code: 4625 ` in the query bar.

<img width="2546" height="1240" alt="image" src="https://github.com/user-attachments/assets/3bbbaea0-0658-4deb-872f-21a8c5eac22d" />

<br>If there are many users with failed login attempts and you wish to narrow down on one, the query can be combined using the AND operator.
<br>` event.code: 4625 AND user.name: IEUser `

<img width="2550" height="1162" alt="image" src="https://github.com/user-attachments/assets/5e63c8ac-f9e2-4808-b117-da0a7b95e292" />

<br> Multiple conditions can be combined such as limiting to one endpoint's IP, one user account and searching for successful logins (code 4624).
` event.code: 4624 AND user.name: * and host.ip: 172.16.50.10 `

<img width="2539" height="912" alt="image" src="https://github.com/user-attachments/assets/7914f38e-6e0e-41d3-a9fc-d480af7272ab" />

<br>Running of particular processes can also be displayed using ` process.name: {processname} AND event.action: "Process creation"` .
<br>In this case, the search is used to display the process PING.EXE

<img width="2554" height="1190" alt="image" src="https://github.com/user-attachments/assets/63868a20-1054-4e2c-a37a-e08096a9b452" />

