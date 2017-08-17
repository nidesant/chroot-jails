## Chrooting Web Servers

It is important to not that chrooting a web server does not make it automatically more secure. The benefit is that it restricts apache/nginx and their subprocceses to a very small subset of the filesystem. So, the benefit isn't as much defensive, but moreso to contain a potential threat. 

## Advantages

As previosuly stated, if an attacker is successful in gaining entry, they will only be restricted to the files and binaries within the chroot jail. If you are using apache, this has the additional benefit of potentially dangerous CGI scripts not having access to your server's filesystem. 

## Caveats

Chroot jails are particularly difficult to setup and maintain if you are using more than just the base web stack or running external software, i.e a LAMP stack or a similar setup. These scripts only provide the base setup for your web server over SSL. So, at the least, you will be provided with a base configuartion / filesystem  for the jail.

## Systemd Distros

On a classic System-V-based operating system it is relatively easy to use chroot() environments. For example, to start a specific daemon for test or other reasons inside a chroot()-based guest OS tree, mount /proc, /sys and a few other API file systems into the tree, and then use chroot(1) to enter the chroot, and finally run the SysV init script via /sbin/service from inside the chroot. However, on systemd based distros, this becomes more complicated. The two main reasons are, 1) the actual daemon is always spawned off PID 1 and thus inherits the chroot() settings from it, so it is irrelevant whether the client which asked for the daemon to start is chroot()ed or not, and, 2) since systemd actually places its local communications sockets in /run/systemd, a process in a chroot() environment will not even be able to talk to the init system. Below is a sample of a custom nginx.service file for CentOS 7.x, which chroots the daemon on startup. There are detailed steps to working around this in this article: http://0pointer.de/blog/projects/changing-roots

```
[Unit]
Description=A high performance web server and a reverse proxy server in a chroot jail
After=syslog.target network.target

[Service]
Type=forking
PIDFile=/var/www/chroot/run/nginx.pid
ExecStartPre=/usr/sbin/chroot  /var/www/chroot /usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/chroot  /var/www/chroot /usr/sbin/nginx -g 'daemon on; master_process on;'
ExecStartPost=/bin/sleep 0.1
ExecReload=/usr/sbin/chroot  /var/www/chroot /usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=/usr/sbin/chroot  /var/www/chroot /usr/sbin/nginx -s stop

[Install]
WantedBy=multi-user.target
```

## Additional

If you are using apache and you do not want to use this script to create the /etc /dev and /lib directories, then the mod_chroot() module will allow you to run a chroot jail with no additional files. The chroot() system call is performed at the end of startup procedure – when all libraries are loaded and log files open. For instructions on installing and configuring the module, follow this link:
https://www.cyberciti.biz/tips/chroot-apache-under-rhel-fedora-centos-linux.html

### TO DO
- add a php function to scripts for more flexibility 
- configure syslog 
- make debain scripts 
- configure https
