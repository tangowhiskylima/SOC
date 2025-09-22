# Install Elastic Agent on ELK VM

To receive pfSense firewall logs on the ELK, we will install Elastic agent on the ELK server and configure the pfSense to send the logs remotely to ELK. <br>

Log in to Elasticsearch through the Kibana webpage and scroll down to Management > Integrations.

<img width="263" height="295" alt="image" src="https://github.com/user-attachments/assets/39f3c306-8011-492e-b744-5130c17b0a9c" />

Search for pfSense in the search bar and click on pfSense to initiate the Elastic Agent install.

<img width="1013" height="498" alt="image" src="https://github.com/user-attachments/assets/f14bbbd0-d6f8-4096-967e-1a902b7a4197" />

Click on Add pfSense at the right. 

<img width="2136" height="409" alt="image" src="https://github.com/user-attachments/assets/b882a0b3-1984-41d6-8241-23e23450f273" />

A configuration page will be shown. Enter the desired port and click on Save and Continue at the bottom right.

<img width="2516" height="1220" alt="image" src="https://github.com/user-attachments/assets/c3386fa3-0e8f-4bdc-b534-f3d263c237e8" />

A popup window will appear. Click on Add Elastic Agent to your hosts.

<img width="842" height="234" alt="image" src="https://github.com/user-attachments/assets/6b33b0c5-5970-4cd4-bc60-946e6f5bb4de" />

Click on Add Agent and select Run standalone.

<img width="2331" height="316" alt="image" src="https://github.com/user-attachments/assets/59f5d2d8-e7c2-4c5d-afbd-04ce5c30f6e6" /><img width="808" height="433" alt="image" src="https://github.com/user-attachments/assets/891fd3c2-5fd8-4a32-9f4b-46782a470594" />

You will be brought to the agent configuration page. Click Create API Key.

<img width="772" height="909" alt="image" src="https://github.com/user-attachments/assets/9935a216-2176-4e52-b96e-c1726d55a90f" />

Scroll down and select the appropriate installation instructions, in this case select Linux X86_64.

<img width="760" height="683" alt="image" src="https://github.com/user-attachments/assets/0a6233b2-b033-4bae-8263-e36e029122c1" />

Run the commands shown in the ELK VM to install Elastic Agent. The installation will be under /opt/Elastic/Agent. You need to replace the contents of elastic-agent.yml with what was provided by the configuration page earlier. Then restart the elastic-agent service.

<img width="735" height="753" alt="image" src="https://github.com/user-attachments/assets/dc343642-853a-4d49-9dc2-f8a980f3d791" />

Now login to pfSense, go to Status > System Logs > Click on Settings.

<img width="1739" height="664" alt="image" src="https://github.com/user-attachments/assets/caf66f2b-781a-4f34-a135-6e2e21fc9cd3" />

For the log format, choose syslog from the dropdown list.

<img width="1188" height="1078" alt="image" src="https://github.com/user-attachments/assets/895261e0-a4e1-4d28-8510-b9b81171be70" />

Scroll down and check enable remote logging. Enter the IP Address of ELK VM and port number that was configured in the elastic agent installation earlier. You can customize the type of logs to be sent or just select everything. Click on Save.

<img width="1161" height="788" alt="image" src="https://github.com/user-attachments/assets/e5a45809-ec60-4537-8016-aab6b5cbfa3f" />

