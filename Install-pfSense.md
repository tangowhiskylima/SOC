# Setting up pfSense

Get pfSense Community Edition [here](https://atxfiles.netgate.com/mirror/downloads/)<br>

During the installation, ensure that 3 network adapters are created on your VM to simulate the WAN, LAN and DMZ segmentation.

After installation is complete, the following options should be displayed.

<img width="2026" height="770" alt="image" src="https://github.com/user-attachments/assets/be703c5a-fb3c-4684-b3f6-4c38f893da53" />

Enter 1 to start assigning interfaces.

Since the VM has 3 interfaces created, it should show em0, em1 and em2.

<img width="1210" height="711" alt="image" src="https://github.com/user-attachments/assets/5a9217e1-a042-40fd-bcab-726387b346b1" />

Select no for setting up VLANs.

Enter the names for each interface as follows

<img width="1290" height="715" alt="image" src="https://github.com/user-attachments/assets/2217c86c-e8fb-4507-abbe-a348f4b2cdc8" />

Next we will select option 2 to set the interface IP Address for LAN and OPT1 (DMZ). You can use your own IP addressing as long as no confliction happens.

<img width="1064" height="567" alt="image" src="https://github.com/user-attachments/assets/586580e9-cb1e-46b2-8fe9-a4a3f8956eb1" />

Once all 3 interfaces IP are configured, it should show something like this.

<img width="1826" height="293" alt="image" src="https://github.com/user-attachments/assets/6cf5c678-8b0a-43fd-94e4-40f127822a61" />

Next we will enable the Web UI to access the pfSense configuration from browser.

Select 8 to log into pfSense shell and key in ` pfctl -d ` <br>
This disables the firewall temporarily to allow access to the Web UI. 

<img width="1418" height="834" alt="image" src="https://github.com/user-attachments/assets/8e9c9f29-2e6c-40b4-86c1-a7ffad711a05" />

Open a browser and key in the WAN address. A login page should appear. Enter the default credentials to access the UI.

<img width="491" height="338" alt="image" src="https://github.com/user-attachments/assets/6d2f4106-863f-4cdf-9bc6-28d54ea24aea" />

It should bring you to the setup wizard process. Click next until the General Information page and enter a hostname for the firewall. <br>
For the primary and secondary DNS servers, use google (8.8.8.8/8.8.4.4) or cloudflare's (1.1.1.1) DNS. <br>

<img width="918" height="706" alt="image" src="https://github.com/user-attachments/assets/0518e5fa-0af8-4e6b-ba2d-5070863dbb09" />

Next, set up your correct timezone.

<img width="1164" height="561" alt="image" src="https://github.com/user-attachments/assets/a7078e76-9e1e-476f-94ce-1f9c62907f65" />

Next, uncheck the following 2 options.

<img width="1160" height="329" alt="image" src="https://github.com/user-attachments/assets/4f9e4a75-3bac-40e5-98c4-97927c0bc01a" />

Click next until you see the reload in progress message

<img width="1773" height="506" alt="image" src="https://github.com/user-attachments/assets/8d5691d1-9edd-4fe6-90c9-574ad4b674d7" />

Access the Web UI and try to relogin. If unable to access the Web UI, login into pfSense shell and run ` pfctl -d ` one more time. <br>
Once logged in, the pfSense dashboard should be displayed and showing the 3 interfaces status as Up. <br>

Next is to add a rule to allow WAN access to the Web UI so there is no need to run ` pfctl -d ` each time we wish to login to configure the firewall. <br>
At the top menu, click on Firewall then Rules and select WAN interface.

<img width="1094" height="347" alt="image" src="https://github.com/user-attachments/assets/4a8a1dc7-8f8a-4e30-8439-09a3d8b1b9b5" />

Click the Add button to add a new rule.

<img width="1220" height="584" alt="image" src="https://github.com/user-attachments/assets/9df87faa-4709-4aa1-998f-13b4ba266bbc" />

Under the Edit Firewall Rule.
Set Action to Pass
Set Protocol to TCP

<img width="1144" height="458" alt="image" src="https://github.com/user-attachments/assets/b9dbb4ff-d6c1-4337-9e3f-8e41205aaf22" />

For Source, leave it as Any. <br>
For Destination, select This Firewall (self) and Destination Port Range as HTTPS.

<img width="1141" height="170" alt="image" src="https://github.com/user-attachments/assets/6e67b897-44e7-4e6b-afe2-bf8019011aac" />

Under Extra options, you may choose to log or not log packets that are handled by this rule. You can also add a description for this rule.

<img width="666" height="265" alt="image" src="https://github.com/user-attachments/assets/096a9aa8-4d4c-49f6-9922-d1ff6c1868f9" />

Click Save and then Apply Changes.

<img width="1065" height="145" alt="image" src="https://github.com/user-attachments/assets/627ac2c1-f29c-4116-96e0-9e721e8824d6" />

This would conclude the initial setup of the pfSense firewall.

