A home lab that simulates a network of DMZ, WAN and LAN. DMZ contains a Cowrie Honeypot, LAN consists of an ELK stack within an Ubuntu 22.04 VM. WAN will be simulated via the host machine and running a pfSense firewall VM to simulate the necessary network segmentation.

# Updates in progress

## Setting up

1. [Setting up pfSense](/Install-pfSense.md)
2. [Install ELK](/Install-ELK.md)
3. Create another Ubuntu VM and [Install Cowrie](https://docs.cowrie.org/en/latest/INSTALL.html). Put the VM in the DMZ segment and create the netplan yaml file accordingly.
4. [Install Filebeat](/Install-Filebeat.md)
5. [Configure ELK](/Config-ELK.md)
6. [Install Elastic-agent](/Install-Elastic-agent.md) on ELK to receive pfSense logs
