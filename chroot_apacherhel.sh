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

function apache_libs {
  cp /lib64/libpcre.so.1 $D/lib64/
  cp /lib64/libselinux.so.1 $D/lib64/
  cp /lib64/libaprutil-1.so.0 $D/lib64/
  cp /lib64/libcrypt.so.1 $D/lib64/
  cp /lib64/libexpat.so.1 $D/lib64/
  cp /lib64/libdb-5.3.so $D/lib64/
  cp /lib64/libapr-1.so.0 $D/lib64/
  cp /lib64/libpthread.so.0 $D/lib64/
  cp /lib64/libdl.so.2 $D/lib64/
  cp /lib64/libc.so.6 $D/lib64/
  cp /lib64/ld-linux-x86-64.so.2 $D/lib64/ 
  cp /lib64/libuuid.so.1 $D/lib64/
  cp /lib64/libfreebl3.so $D/lib64/

  # Libraries for networking functionality
  cp /lib64/libnss_compat* $D/lib64/
  cp /lib6464/libnss_dns* $D/lib64/
  cp /lib6464/libnss_files* $D/lib64/
  cp /lib6464/libnsl* $D/lib64/
}

# Fucntion calls
make_chroot
apache_libs

# Kill all exisiting apache processes before starting chroot jail
killall httpd

# Starts chroot jail
chroot $D /etc/httpd

# Will start chroot jail after system reboot
echo '/usr/sbin/chroot $D /etc/httpd' >> /etc/rc.d/rc.local 
