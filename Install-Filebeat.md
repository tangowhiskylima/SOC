# Installing Filebeat

Filebeat is used to send the logs to ELK stack. Filebeat installation guide can be found [here](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation-configuration.html).<br>
Filebeat will be installed on the Ubuntu VM housing Cowrie Honeypot. <br>

### Installation commands
` curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-9.1.3-amd64.deb `

` sudo dpkg -i filebeat-9.1.3-amd64.deb `

### Configure Filebeat


