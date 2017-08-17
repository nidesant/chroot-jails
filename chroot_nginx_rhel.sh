#!/bin/bash

# This script automates the creation of chroot jails for nginx web servers.
# Please note that this chroot jail is for CentOS 7.x servers and is not guranteed to work on older versions. 

# chroot root directory
D=/var/www/chroot

# Function copies necessary directories, files, libraries, modules, etc. necessary to run the chroot
function make_chroot {
  mkdir -p $D
  mkdir -p $D/usr/lib64/nginx
  mkdir -p $D/proc
  mkdir -p $D/usr/share/nginx
  mkdir -p $D/var/{log,lib}/nginx
  mkdir -p $D/www/cgi-bin
  mkdir -p $D/run
  mkdir -p $D/lib64
  mkdir -p $D/etc
  mkdir -p $D/dev
  mkdir -p $D/var
  mkdir -p $D/var/tmp
  mkdir -p $D/tmp
  mkdir -p $D/usr/sbin
  mkdir -p $D/usr/lib64/perl5
  mkdir -p $D/usr/share/perl5
  mkdir -p $D/var/lib/nginx/
  chmod 1777 $D/tmp
  chmod 1777 $D/var/tmp

  mknod -m 0666 $D/dev/null c 1 3
  mknod -m 0666 $D/dev/random c 1 8
  mknod -m 0444 $D/dev/urandom c 1 9
    
  cp -farv /etc/{group,prelink.cache,services,adjtime,shells,gshadow,shadow,hosts.deny,localtime,nsswitch.conf,nscd.conf,prelink.conf,protocols,hosts,passwd,ld.so.cache,ld.so.conf,resolv.conf,host.conf} $D/etc
  cp -farv /etc/nginx/ $D/etc/
  cp -avr /etc/{ld.so.conf.d,prelink.conf.d} $D/etc
  cp /usr/sbin/nginx $D/usr/sbin/
  cp -r /usr/share/nginx/* $D/usr/share/nginx
  cp -r /var/lib/nginx $D/var/lib/nginx
  cp -r /proc/cpuinfo $D/proc
  cp -r /usr/lib64/nginx/modules/ $D/usr/lib64/nginx/
  cp -r /var/log/nginx $D/var/log/
  cp -r /usr/lib64/perl5/vendor_perl $D/usr/lib64/perl5/
  cp -r /usr/share/perl5/ $D/usr/share/
  cp -r /var/lib/nginx/ $D/var/lib/
  cp /usr/sbin/chroot $D/usr/sbin/
 
  chown -R root:root $D/
  chown -R nginx:nginx $D/www
  chown -R nginx:nginx $D/etc/nginx
  chown -R nginx:nginx $D/var/{log,lib}/nginx/
  chown -R nginx:nginx $D/run/nginx.pid
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
  cp /lib64/libprofiler.so.0 $D/lib64
  cp /lib64/libc.so.6 $D/lib64
  cp /lib64/ld-linux-x86-64.so.2 $D/lib64 
  cp /lib64/libfreebl3.so $D/lib64
  cp /lib64/libgssapi_krb5.so.2 $D/lib64
  cp /lib64/libkrb5.so.3 $D/lib64
  cp /lib64/libcom_err.so.2 $D/lib64
  cp /lib64/libk5crypto.so.3 $D/lib64
  cp /lib64/libunwind.so.8 $D/lib64
  cp /lib64/libstdc++.so.6 $D/lib64
  cp /lib64/libm.so.6 $D/lib64
  cp /lib64/libgcc_s.so.1 $D/lib64
  cp /lib64/libkrb5support.so.0 $D/lib64
  cp /lib64/libkeyutils.so.1 $D/lib64
  cp /lib64/libresolv.so.2 $D/lib64
  cp /lib64/libselinux.so.1 $D/lib64
  cp /lib64/libm.so.6 $D/lib64
  cp /lib64/libGeoIP.so.1 $D/lib64
  cp /lib64/libgd.so.2 $D/lib64
  cp /lib64/libXpm.so.4 $D/lib64
  cp /lib64/libX11.so.6 $D/lib64
  cp /lib64/libjpeg.so.62 $D/lib64
  cp /lib64/libfontconfig.so.1 $D/lib64
  cp /lib64/libfreetype.so.6 $D/lib64
  cp /lib64/libpng15.so.15 $D/lib64
  cp /lib64/libxcb.so.1 $D/lib64
  cp /lib64/libdl.so.2 $D/lib64
  cp /lib64/libexpat.so.1 $D/lib64
  cp /lib64/libpthread.so.0 $D/lib64
  cp /lib64/libXau.so.6 $D/lib64
  cp /usr/lib64/perl5/CORE/libperl.so $D/lib64
  cp /lib64/libnsl.so.1 $D/lib64
  cp /lib64/libutil.so.1 $D/lib64
  cp /lib64/libxml2.so.2 $D/lib64
  cp /lib64/libxslt.so.1 $D/lib64
  cp /lib64/libexslt.so.0 $D/lib64 
  cp /lib64/liblzma.so.5 $D/lib64
  cp /lib64/libgcrypt.so.11 $D/lib64
  cp /lib64/libgpg-error.so.0 $D/lib64
  cp /lib64/libnss_files-2.17.so $D/lib64
  cp /lib64/libnss_files.so.2 $D/lib64
}
# Function calls
make_chroot
nginx_libs

# Kill existing nginx before starting chrooted nginx
killall -9 nginx

# Gives the chrooted executable permission to bind to ports [0-1023] without being root
setcap 'cap_net_bind_service=+ep' $D/usr/sbin/nginx

# Starts chroot jail (this will start into chroot based on the modifications made to the nginx.service file)
systemctl start nginx

# Sarts chroot jail after system reboot (only for init systems)
#echo 'chroot $D /etc/nginx' >> /etc/rc.local
