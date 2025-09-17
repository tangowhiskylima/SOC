# Installing Filebeat

Filebeat is used to send the logs to ELK stack. Filebeat installation guide can be found [here](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation-configuration.html).<br>
Filebeat will be installed on the Ubuntu VM housing Cowrie Honeypot. <br>

### Installation commands
` curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-9.1.3-amd64.deb `

` sudo dpkg -i filebeat-9.1.3-amd64.deb `

### Configure Filebeat

Configuration to Filebeat is done through editing the /etc/filebeat/filebeat.yml file. A sample version of the yml file (filebeat-cowrie.conf) can be found inside cowrie's installation folder under docs/elk. <br>
Copy the file to /etc/filebeat directory and rename it as filebeat-cowrie.yml then open it with a text editor. <br>

Inside the Filebeat Inputs sections, edit the following lines: <br>
1. Change the type to filestream
2. Enter a unique ID for the input. This ID will allow the Filebeat to track the file state of the logs during log rotation.
3. Ensure enabled is set to true
4. Ensure the paths points to the log file path of the cowrie installation
   
<img width="821" height="537" alt="image" src="https://github.com/user-attachments/assets/13723417-c0f8-4dad-8698-81842eb32eae" />

For the output section, disable Elasticsearch output by commenting out the lines

` output.elasticsearch: ` and
` hosts: ... `

<img width="539" height="136" alt="image" src="https://github.com/user-attachments/assets/5db70112-09b0-4d7c-9251-1032484e922b" />

Enable logstash output by uncommenting

` output.logstash: ` <br>

and including the ELK IP and port inside ` hosts: [IP:PORT] `

<img width="498" height="131" alt="image" src="https://github.com/user-attachments/assets/0446bfe8-8337-44a3-8d97-932574b45885" />

Restart the Filebeat service.

` systemctl restart filebeat `
