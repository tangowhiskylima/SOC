# Creating Alerts in ELK

The searches can be automated into alert rules for ELK to display on the dashboard when certain conditions are met.

<img width="2553" height="1293" alt="image" src="https://github.com/user-attachments/assets/df4c2131-83e5-40be-b0fc-0516f1695b36" />

<br>For example, to create a rule to detect brute forcing on the honeypot, a Threshold rule will be created. <br>
<br>Select Security > Rules from the main menu.

<img width="311" height="739" alt="image" src="https://github.com/user-attachments/assets/f3152821-1e60-450f-84f4-57a44a051a6c" />

<br>Select Detection Rules (SIEM)

<img width="1669" height="557" alt="image" src="https://github.com/user-attachments/assets/02474408-c888-4994-b73a-0436bc892aef" />

<br>Select Create new rule

<img width="2517" height="641" alt="image" src="https://github.com/user-attachments/assets/03dec71e-20ae-4e71-92ab-e9a4e9c226c2" />

<br>Select Threshold

<img width="2543" height="1128" alt="image" src="https://github.com/user-attachments/assets/3a022a6d-49cc-48e6-92a7-c4ac95053cb1" />

Take note of the rule preview on the right hand side. This allows us to test the rule before actually creating and enabling it.

<img width="2541" height="1196" alt="image" src="https://github.com/user-attachments/assets/53b66678-b4f0-4b0b-b303-1909cedf0978" />

<br>Under source, select the source for the rules query to search the events in. In this case, the data view created earlier for cowrie will be used.
<br>For custom query, we will search for login failed event for the user root. ` honeypot.eventid: cowrie.login.failed AND honeypot.username: root `
<br>Under the Group by tab, key in host.ip.keyword and enter a threshold for the brute force attempts. In this case a relatively low number, 3, was used.
<br>Click on Continue 

<img width="1769" height="1116" alt="image" src="https://github.com/user-attachments/assets/5d28f37a-d5f3-4c4c-98f2-d0b64186a6a3" />

<br>In this section, more details about the rule can be entered to allow all users who view this alert to know what this rule is about.
<br>Criticality is also specified here in order to accord the appropriate priority.

<img width="2539" height="1211" alt="image" src="https://github.com/user-attachments/assets/2a734301-877c-4987-9bb9-bb749baa346d" />

<br>Click on Advanced Settings, the rule can also specify which TTP is it according to the MITRE ATT&CK framework.

<img width="1566" height="1032" alt="image" src="https://github.com/user-attachments/assets/ae81b000-6ad5-4248-8f72-55371eb6f0d8" />

<br>Investigation guide can also be included to help analysts investigating the alerts. This can be steps extracted from the playbook.
<br>Click on Continue

<img width="2539" height="1061" alt="image" src="https://github.com/user-attachments/assets/2fcbf0c0-b823-4187-9c31-f7b2635be4e1" />

<br>This next screen determines how often the rule will run. In this case, this means the rule will be activated when 3 or more failed login attempts happen within 3 minutes.
<br>Click on Continue to head to the last section of the rule creation, which is the action ELK will take upon positive detection.

<img width="2543" height="1092" alt="image" src="https://github.com/user-attachments/assets/91b5f9ee-1b8e-4e46-b4c3-3fffb0a1aa36" />

<br>This section is not mandatory. Most of the features are not available in the free version. Various actions can be configured with the right license such as sending email, or creating a ticket or sending a message.
<br>In this case where no actions are configured, the rule will be displayed as an alert in the alerts dashboard.

<img width="1562" height="1179" alt="image" src="https://github.com/user-attachments/assets/04e97c6e-8637-4d9f-8c40-f073bf327b00" />

<br>Test the rule using Rule Preview by clicking refresh for the selected timeframe.
<br>A table should show up with the alerts created.
<br>Complete the creation by clicking Create & enable rule.

<img width="2535" height="915" alt="image" src="https://github.com/user-attachments/assets/e3a4cbd9-3d46-4ad7-86ce-dee0467de1c2" />

# Viewing Alerts

<br>When the rule is activated, in this case every 3 mins, the alerts can be viewed under Security > Alerts.

<img width="2552" height="848" alt="image" src="https://github.com/user-attachments/assets/cd6214fe-b3d7-4306-9c02-3cda3cbcb08c" />

<br>To display more information about an alert, under the Actions column, click the expand icon then on the bottom right corner, click Take Action > Investigate in Timeline

<img width="2486" height="1222" alt="image" src="https://github.com/user-attachments/assets/d9b3e0a3-e66e-47d6-9033-84d13a63b34f" />

<br>This will open up a separate view that will display the details of each event that contributed to the activation of the rule.
<br>From here, details of the event such as hostname, host ip can be seen for the analyst to further investigate the alert.
<br>On the left hand menu, relevant columns can be toggled to display the important information.
<br>In this case, we can include the source ip of the brute force attempt.

<img width="1278" height="1116" alt="image" src="https://github.com/user-attachments/assets/ceb6c3b7-c842-445d-a2ae-2ddaec80d497" />
