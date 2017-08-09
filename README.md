## Chrooting Web Servers

It is important to not that chrooting a web server does not make it automatically more secure. The benefit is that it restricts apache/nginx and their subprocceses to a very small subset of the filesystem. So, the benefit isn't as much defensive, but moreso to contain a potential threat. 

## Advantages

As previosuly stated, if an attacker is successful in gaining entry, they will only be restricted to the files and binaries within the chroot jail. If you are using apache, this has the additional benefit of potentially dangerous CGI scripts not having access to your server's filesystem. 

## Caveats

Chroot jails are particularly difficult to setup and maintain if you are using more than just the base web stack or running external software, i.e a LAMP stack or a similar setup. These scripts only provide the base setup for your web server over SSL. So, at the least, you will be provided with a base configuartion / filesystem  for the jail.

## Additional

If you are using apache and you do not want to use this script to create the /etc /dev and /lib directories, then the mod_chroot() module will allow you to run a chroot jail with no additional files. The chroot() system call is performed at the end of startup procedure – when all libraries are loaded and log files open. For instructions on installing and configuring the module, follow this link:
https://www.cyberciti.biz/tips/chroot-apache-under-rhel-fedora-centos-linux.html

### TO DO
- add a php function to scripts for mroe flexibility 
