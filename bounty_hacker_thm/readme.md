Bounty Hacker
You talked a big game about being the most elite hacker in the solar system. Prove it and claim your right to the status of Elite Bounty Hacker!

IP : 10.10.21.54

Anonymous FTP gives us a "Locks" list with random seemingly passwords, and the only thing that is open is ssh
So i tried to bruteforce SSH with locks.txt

-lin left the taskslist on the FTP, with the locks.txt file, so we can assume this is a potential username on the machine, for the sake of completeness i also added all the "Crew" names i found on the website:

``
[22][ssh] host: 10.10.21.54   login: lin   password: RedDr4gonSynd1cat3
[STATUS] attack finished for 10.10.21.54 (waiting for children to complete tests)
``

```
hydra -L ../../possible_user.txt -P ./locks.txt 10.10.21.54 ssh -v
```

After login GTFObins tar was executeable with Sudo,

GTFObins -> Tar SUDO exploit -> root.
