#!/bin/bash

# This script automates the creation of chroot jails for nginx web servers.

D=/var/www/chroot

function make_chroot {
    mkdir -p $D
    mkdir -p $D/usr/share/nginx
    mkdir -p $D/var/{log,lib}/nginx
    mkdir -p $D/www/cgi-bin
    mkdir -p $D/run
    mkdir -p $D/sbin
    mkdir -p $D/lib64
    mkdir -p $D/etc
    mkdir -p $D/dev
    mkdir -p $D/var
    mkdir -p $D/var/tmp
    mkdir -p $D/tmp
    chmod 1777 $D/tmp
    chmod 1777 $D/var/tmp

    mknod -m 0666 $D/dev/null c 1 3
    mknod -m 0666 $D/dev/random c 1 8
    mknod -m 0444 $D/dev/urandom c 1 9
    
    cp -farv /etc/{group,prelink.cache,services,adjtime,shells,gshadow,shadow,hosts.deny,localtime,nsswitch.conf,nscd.conf,prelink.conf,protocols,hosts,passwd,ld.so.cache,ld.so.conf,resolv.conf,host.conf} $D/etc
    cp -farv /etc/nginx/* $D/etc/
    cp -avr /etc/{ld.so.conf.d,prelink.conf.d} $D/etc
    cp /sbin/nginx $D/sbin/
    cp -r /usr/share/nginx/* $D/usr/share/nginx
    cp -r /var/lib/nginx $D/var/lib/nginx
}

# Required libraries for nginx
function nginx_libs {
    cp /lib64/libdl.so.2 $D/lib64
    cp /lib64/libpthread.so.0 $D/lib64
    cp /lib64/libcrypt.so.1 $D/lib64
    cp /lib64/libpcre.so.1 $D/lib64
    cp /lib64/libssl.so.10 $D/lib64
    cp /lib64/libcrypto.so.10 $D/lib64
    cp /lib64/libz.so.1 $D/lib64
    cp /lib64/libc.so.6 $D/lib64
    cp /lib64/ld-linux-x86-64.so.2 $D/lib64
    cp /lib64/libfreebl3.so $D/lib64
    cp /lib64/libgssapi_krb5.so.2 $D/lib64
    cp /lib64/libkrb5.so.3 $D/lib64
    cp /lib64/libcom_err.so.2 $D/lib64
    cp /lib64/libk5crypto.so.3 $D/lib64
    cp /lib64/libkrb5support.so.0 $D/lib64
    cp /lib64/libkeyutils.so.1 $D/lib64
    cp /lib64/libresolv.so.2 $D/lib64
    cp /lib64/libselinux.so.1 $D/lib64
    cp /lib64/liblzma.so.5 $D/lib64 

# Function calls
make_chroot
nginx_libs

# Kill existing nginx before starting chrooted nginx
killall -9 nginx

# Starts chroot jail (this will start into chroot based on the modifications made to the nginx.service file)
systemctl start nginx

# Sarts chroot jail after system reboot (only for init systems)
#echo 'chroot $D /etc/nginx' >> /etc/rc.local



