# Linux Commands
Show current directy:
```
ls -ad
```
Make a directory:
```
sudo mkdir /path/to/directory
```
Remove a empty directory:
```
sudo rm -d /path/to/directory
```
Remove a non-empty directory:
```
sudo rm -r /path/to/directory
```
Change folder permissions:
<pre>
-need to use sudo   
-u is for user, g is for group, 0 is for others, ugo or a is for all   
-r is for read, w is for write, and x is for execute   
</pre>
<pre>
• chmod +rwx filename to add permissions.
• chmod -rwx directoryname to remove permissions.
• chmod +x filename to allow executable permissions.
• chmod -wx filename to take out write and executable permissions.
• chmod -R (this is recursive and will change subdirectories also) 
• chmod -R 777 (this will give full rights to everyone) 
</pre>
<pre>
# Change folder ownership:   
Change owner of a file or directory:
  • chown newowner "file or directory"
Change owner and group of a file or directory:
  • chown newowner:newgroup "file or directory"
Change owner of a directory and its contents recursively:
  • chown -R newowner "file or directory"
Change only the group of a file or directory:
  • chown :newgroup "file or directory"
Preserve the root user as the owner while changing group:
  • chown root:newgroup "file or directory"
</pre>
Install Net tool
```
sudo apt update && sudo apt-get install net-tools
```
Install SSH 
```
sudo apt update && sudo apt-get install openssh-server
```
Find Public IP
```
dig +short myip.opendns.com @resolver1.opendns.com
```






















