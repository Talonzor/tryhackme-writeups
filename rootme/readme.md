```
  Room: RootMe
  link: https://tryhackme.com/room/rrootme
  Difficulty: Beginner
```

This room was really straight forward.2
1. Run Nmap
2. Run Gobuster

We found a odd dir under /panel/

This gives us the opportunity to upload a file.

  We create a php reverse shell and open shell on our local machine with:
    rlwrap nc -lvnp 4444


Whilst uploading we figure out .php is not allowed, after some trial and error i find that .phtml is allowed.

go to /uploads/ and execute the reverse shell file.


cat user.txt gives us the first flag. Now how to get RootMe
  look for all SUID files, find python.
  check GTFObins
Python : https://gtfobins.github.io/gtfobins/python/#shell

Command that elevated me to root:
  ```
  ./python -c 'import os; os.execl("/bin/sh", "sh", "-p")'
  ```

Completed in about 15 minutes.
