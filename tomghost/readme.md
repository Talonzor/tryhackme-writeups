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
