# Startup |  Welcome to Spice Hut!
```
  CTF : "Startup"
  URL : https://tryhackme.com/room/startup
  Style: Unguided
  Difficulty : Easy
```

Nmap gave us some results, but nothing spectacular.

The main IP gave us the "All setup" Page for Apache, we ran Gobuster on it and found "/simple/" as an url.

This runs CMS made Simple V2.2.8.
  Lets check Exploit DB if we can find something to abuse this with:
    https://www.exploit-db.com/exploits/46635

Download .py file
  Could not get Python 2 to work, so instead i adjusted the script to be Python3 compatible

    Mostly print with parenthesis print ("") vs print ""

Script output:
```
  [+] Salt for password found: 1dac0d92e9fa6bb2
  [+] Username found: mitch
  [+] Email found: admin@admin.com
  [+] Password found: 0c01f4468bd75d7a84c7eb73846e8d96
```
0c01f4468bd75d7a84c7eb73846e8d96:1dac0d92e9fa6bb2
Cracked with Hashcat;
  ``.\hashcat.exe .\hashes\hash.txt -m 20 'C:\Users\Michael Panneman\Downloads\rockyou (1).txt'``

password: `secret`


Used Login to connect to ssh (on port 2222).

cat user.txt finds the userflag.


Now to escalate privileges;
``sudo -l``

Shows VIM can be run with SUDO without password.

gtfobins.com
  ``vim -c ':!/bin/sh'``
