#!/bin/bash 

D=/var/www/chroot/

function make_chroot {
  mkdir -p $D
  mkdir -p $D/bin
  mkdir -p $D/run
  mkdir -p $D/dev
  mkdir -p $D/lib
  mkdir -p $D/etc
  mkdir -p $D/usr/sbin
  mkdir -p $D/lib64
  mkdir -p $D/usr/lib64/httpd
  mkdir -p $D/usr/libexec
  mkdir -p $D/var/log/httpd
  mkdir -p $D/var/www/html
  mkdir -p $D/home/httpd
  mkdir $D/etc/sysconfig 
  chown -R root:root $D
  chmod -R 0755 $D

  cp -r /etc/httpd/ $D/etc/
  cp /usr/sbin/httpd $D/usr/sbin/
  cp -a /etc/ssl $D/etc/
  cp /usr/sbin/httpd $D/usr/sbin/
  cp /etc/hosts $D/etc/
  cp /etc/host.conf $D/etc/
  cp /etc/resolv.conf $D/etc/
  cp /etc/nsswitch.conf $D/etc/
  cp /usr/sbin/chroot $D/usr/sbin/
  cp /usr/sbin/apachectl $D/usr/sbin
  cp /etc/sysconfig/httpd $D/etc/sysconfig
  cp /bin/kill $D/bin/
  cp -r /usr/lib64/httpd/modules/ $D/usr/lib64/httpd
  cp /etc/passwd $D/etc/
  cp /etc/group $D/etc/
  cp -r /var/www/html/ $D/var/www/
  cp /etc/hostname $D/etc/
  cp /etc/mime.types $D/etc/
  cp -r /run/httpd/ $D/run
 
  mknod -m 0666 $D/dev/null c 1 3
  mknod -m 0666 $D/dev/random c 1 8
  mknod -m 0444 $D/dev/urandom c 1 9  
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
  cp /lib64/libz.so.1 $D/lib64
  cp /lib64/liblua-5.1.so $D/lib64
  cp /lib64/libm.so.6 $D/lib64
  cp /lib64/libsystemd-daemon.so.0 $D/lib64
  cp /lib64/librt.so.1 $D/lib64 
  cp /lib64/libcap.so.2 $D/lib64
  cp /lib64/libdw.so.1 $D/lib64
  cp /lib64/libgcc_s.so.1 $D/lib64
  cp /lib64/libattr.so.1 $D/lib64
  cp /lib64/libelf.so.1 $D/lib64
  cp /lib64/liblzma.so.5 $D/lib64 
  cp /lib64/libbz2.so.1 $D/lib64
  cp /lib64/libnss_files-2.17.so $D/lib64
  cp /lib64/libnss_files.so.2 $D/lib64

  # Libraries for networking functionality
  #cp /lib64/libnss_compat* $D/lib64/
  #cp /lib6464/libnss_dns* $D/lib64/
  #cp /lib6464/libnss_files* $D/lib64/
  #cp /lib6464/libnsl* $D/lib64/
}

# Fucntion calls
make_chroot
apache_libs

# Kill all exisiting apache processes before starting chroot jail
killall -9 httpd

# Starts chroot jail
systemctl start httpd

# Will start chroot jail after system reboot
#echo '/usr/sbin/chroot $D /etc/httpd' >> /etc/rc.d/rc.local 
