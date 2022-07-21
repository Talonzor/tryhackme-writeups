1. Did default scans.
2. Found WordPress website on /retro/
3. Only poster is user named "wade", found random comment says "If i forget to spell it, with `parzival`". This turned out to be the password.
4. Since we're now in WordPress with access, we can make a reverse shell from a WP Plugin as we've done before.
5. We use c99-webshell.php to spawn a Full PHP webshell. Unfortunately this is a windows machine.

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
