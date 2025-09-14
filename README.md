A home lab that simulates a network of DMZ, WAN and LAN. DMZ contains a Cowrie Honeypot, LAN consists of an ELK stack within an Ubuntu 22.04 VM and a Win 10 VM. WAN will be simulated via the host machine and running a pfSense firewall VM to simulate the necessary network segmentation.

## Updates in progress

# Installing ELK on Ubuntu

ELK can be installed via apt and the installation guide can be found at https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-with-debian-package

First import the repository gpg key and include the respository link with the following commands: <br>

` wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg ` 

` echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/9.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-9.x.list `

Run sudo apt update to update the repository list <br>

` sudo apt update `

Proceed to install elasticsearch, kibana and logstash

` sudo apt install elasticsearch kibana logstash `

Once installation is complete, the following section would be displayed. Take note of the generated password and the commands to regen the superuser password and kibana enrollment token command <br>

<img width="1023" height="600" alt="Screenshot 2025-09-14 203816" src="https://github.com/user-attachments/assets/bb12c284-d35f-4201-8507-fb8ff77e2e4d" />

Run the following command to view the service status, they should show as disabled.

` systemctl status elasticsearch.service kibana.service logstash.service `

<img width="984" height="376" alt="image" src="https://github.com/user-attachments/assets/04fe84fc-bf01-4a55-93ad-54e75618d727" />

Enable the services

` systemctl enable elasticsearch kibana logstash `

Check the status again and they should show enabled.

<img width="978" height="372" alt="image" src="https://github.com/user-attachments/assets/565dbf0c-275a-476f-9a7d-29c6eb964471" />

Now start the services in the following order; elasticsearch, kibana then logstash

` systemctl start elasticsearch `

Checking the status, it should show the service as running

<img width="965" height="379" alt="image" src="https://github.com/user-attachments/assets/f98af935-53cb-4814-8875-309fd44d20e9" />

Run the commands for kibana and logstash and ensure they are running as well.

<img width="732" height="286" alt="image" src="https://github.com/user-attachments/assets/9b6dd7a4-5892-43c6-9702-d3c2017faf84" />

<img width="726" height="267" alt="image" src="https://github.com/user-attachments/assets/cf975cae-cd20-4f0e-a05d-84f76b3a8be4" />

Use a curl command to verify the elasticsearch website is running. Default port is 9200. Replace the password with the generated password earlier.

` curl --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic:PASSWORDGENERATEDEARLIER https://localhost:9200 `

A valid elasticsearch installation will display an output similar to the following:

<img width="843" height="449" alt="image" src="https://github.com/user-attachments/assets/451d7293-30ed-4a8b-8ec9-5bd899e3670e" />

Configure Kibana for remote access. The config file can be found at /etc/kibana/kibana.yml. Uncomment server.port and server.host. Replace server.host with the IP address of the ELK VM.

<img width="519" height="301" alt="image" src="https://github.com/user-attachments/assets/c0a5abd3-0d74-4d4d-a0f0-462dd7485b6f" />

Open a browser and access the kibana page at http://IP:5601. You should see an enrollment page asking for a token.

<img width="863" height="573" alt="image" src="https://github.com/user-attachments/assets/8cfa32a2-34b1-4d9b-a200-74c010180ddd" />

Run the command to generate a token.

` /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana `

A prompt for a verification code will be shown. Run the following command

` /usr/share/kibana/bin/kibana-verification-code `

<img width="688" height="49" alt="image" src="https://github.com/user-attachments/assets/658e3049-8c14-4b33-a135-97ba8e6e08a0" />

Once successful, you will be brought to the elastic login page. Login with user elastic and the password generated during installation and you should see the home page. <br>

Under the menu, click on Alerts and a warning regarding permissions will appear. 

<img width="2343" height="1041" alt="image" src="https://github.com/user-attachments/assets/a37f0d96-425f-4127-a993-1b6b4d834b92" />

To enable the use of alerts/rules, a key will have to be generated to be included in the kibana.yml file.

Run the command and include the generated xpack.encryptedSavedObjects.encryptionKey into the last line of kibana.yml file

` /usr/share/kibana/bin/kibana-encryption-keys generate `

<img width="761" height="441" alt="image" src="https://github.com/user-attachments/assets/678d36d2-af23-43ae-a029-84c23582f03f" />

Restart the kibana service and relogin. Verify that you can access the Alerts menu.

Next we will verify logstash using the command

` /usr/share/logstash/bin/logstash -e 'input { stdin {} } output { stdout {} }' `

Successful execution of the command will display a prompt that will output what you type in logstash format.

<img width="536" height="602" alt="image" src="https://github.com/user-attachments/assets/248bb536-dacd-4fed-9b69-4d2558f9a6ec" />
