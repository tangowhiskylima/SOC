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

To view events that were forwarded by Beats and pfSense, login to the Kibana webpage, under the menu, select Discover.

<img width="2552" height="486" alt="image" src="https://github.com/user-attachments/assets/c1757bda-770a-4e53-a05b-b34430f773d6" />

We can control the time frame we wish to see events for by selecting the appropriate time frame on the right.

<img width="2550" height="484" alt="image" src="https://github.com/user-attachments/assets/a3d629b4-2d2e-406e-a97a-0cbaa9064b4b" />

On the left hand side, we are able to create different data views to view different logs. For instance, selecting pfsense will only display pfsense logs.

<img width="1126" height="527" alt="image" src="https://github.com/user-attachments/assets/9a35b07c-69d3-461c-9ff4-7cdeba7047eb" />


