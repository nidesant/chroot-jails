#!/bin/bash 

D=/var/www/chroot

function make_chroot {
  mkdir -p $D
  mkdir -p $D/dev
  mkdir -p $D/lib
  mkdir -p $D/etc
  mkdir -p $D/usr/sbin
  mkdir -p $D/usr/lib64
  mkdir -p $D/usr/libexec
  mkdir -p $D/var/run
  mkdir -p $D/var/log/apache
  mkdir -p $D/home/httpd
  
  chown -R root $D
  chmod -R 0755 $D
  chmod 750 $D/var/log/apache/

  mknod -m 0666 $D/dev/null c 1 3
  mknod -m 0666 $D/dev/random c 1 8
  mknod -m 0444 $D/dev/urandom c 1 9

  cp -r /etc/httpd $D/etc/
  cp /usr/sbin/httpd $D/chroot/usr/sbin/
  cp -a /etc/ssl $D/etc/
  cp /usr/sbin/httpd $D/usr/sbin/
  cp /etc/hosts $D/etc/
  cp /etc/host.conf $D/etc/
  cp /etc/resolv.conf $D/etc/
  cp /etc/nsswitch.conf $D/etc/

  chattr +i $D/etc/hosts
  chattr +i $D/etc/host.conf
  chattr +i $D/etc/resolv.conf
  chattr +i $D/etc/nsswitch.conf
  chattr +i $D/etc/passwd
  chattr +i $D/etc/group 
}
