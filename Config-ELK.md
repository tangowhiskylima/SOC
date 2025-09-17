# Configuring ELK

We will be configuring Logstash in this section to ingest logs sent by Filebeat at the Cowrie Server. A typical logstash configuration file consists of 3 sections, input, filter (optional) and output.

A sample logstash configuration for Cowrie can be found inside Cowrie installation folder under docs/elk (logstash-cowrie.conf). Copy the contents of this file into /etc/logstash/conf.d directory inside your ELK server. <br>

Open the file with a text editor and edit the input section. It specifies the input as beats for filebeat and the port to listen to, host to indicate the IP address of the ELK server. <br>

<img width="882" height="408" alt="image" src="https://github.com/user-attachments/assets/b20ef4e1-21f6-4910-b435-76348de37ec6" />

Next, the filter plugin will process the logs received. Since the cowrie logs that are transferred are in json format, the json filter is selected. Within the json filter, 2 options are specified; source and target. Source is used to identify the field for the filter plugin to work with. In this case, the filter will look for the field “message”, which contains the key events of the cowrie honeypot logs. The option target specifies the value of each individual field located in the message that will be added to; in this case honeypot. <br>

<img width="713" height="642" alt="image" src="https://github.com/user-attachments/assets/beb10a1a-d65f-437e-a1ff-b4601d6441af" />

Finally, the output section will determine where logstash will send the filtered logs to. In this case, it is sent to elasticsearch in order for us to search for events in the Kibana interface and also stdout. Stdout usually prints the events on screen, however since the logstash was started as a service, stdout will print the events into /var/log/syslog. 

<img width="808" height="502" alt="image" src="https://github.com/user-attachments/assets/25c82f52-ce1e-4fe1-89ab-e198efd229f5" />

As elasticsearch security settings are enabled by default, there are 2 settings required for Logstash to communicate with Elasticsearch. <br>
First the SSL certificate (located at /etc/elasticsearch/certs) that was created during the installation of elasticsearch needs to be copied into a directory of your choosing, in this case it was copied to /etc/logstash/config/certs and renamed to ca.crt <br>

Next an API key is required for the logstash to create the logs in elastic search. The API key can be created through the Kibana UI. From the Kibana homepage menu, scroll down to Stack Management. 

<img width="1036" height="1235" alt="image" src="https://github.com/user-attachments/assets/e25d140c-686b-4c72-89b3-c48536590c6a" />

Select API Keys under Security

<img width="378" height="915" alt="image" src="https://github.com/user-attachments/assets/e61ff89d-f00c-4d50-b2e9-c307a9f5ccf2" />

Click Create API Key and fill in the respective fields. Give it a unique name to identify its use. Adjust the expiry duration as required then click Create API Key. 
<img width="1271" height="697" alt="image" src="https://github.com/user-attachments/assets/0a26b9df-decb-44b2-aecb-e06e5b37d026" />

The encoded key information will be displayed. 

<img width="624" height="330" alt="image" src="https://github.com/user-attachments/assets/5b768eae-2143-4812-ad12-5a850aea0b40" />

You need to switch it to logstash format and copy the value into the output section of logstash configuration file under api_key field. Save the changes, exit the editor and restart the logstash service.

<img width="685" height="546" alt="image" src="https://github.com/user-attachments/assets/c186ee42-faea-403e-ba1c-d570ea476457" />




