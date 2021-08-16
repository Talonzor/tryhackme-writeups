```
  ROOM: https://tryhackme.com/room/inclusion
  Difficulty: Easy
  Style: Unguided
```

We open the IP and see a very basic webpage;

  We can already see the ``article?name=.`` is ripe for Local File Inclusion.
  To test this, we add an arbitrary URL To see what it does:


Grab both /etc/passwd and /etc/shadow

```
 unshadow passwd shadow > unshadow.txt
```

I have attempted to crack the hashes presented in the files, however this was to no avail.

```
PS D:\hashcat-6.2.3> .\hashcat.exe .\files\hash_falconfeast.txt -a 0 '.\rockyou.txt' -O -w 3
```
This was running for a while, but did not catch the password.

Upon further inspection, someone commented out something in the passwd file
``#falconfeast:rootpassword``

I tried to SSH to the machine with falconfeast as user and `rootpassword` as password. This worked...

Now that we have user access we can cat the user.txt for the user flag
```
falconfeast@inclusion:~$ cat user.txt
      [Redacted]
```

Now, how to escalate privilege
  ```
  falconfeast@inclusion:~$ sudo -l
Matching Defaults entries for falconfeast on inclusion:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User falconfeast may run the following commands on inclusion:
    (root) NOPASSWD: /usr/bin/socat
```

We can see socat is allowed to run without a password, checking GTFOBins we found a way to get rootshell from here.

(check https://gtfobins.github.io/gtfobins/socat/)

While the shell is a bit barebones, it allows us to dump root.txt and get the last flag.
