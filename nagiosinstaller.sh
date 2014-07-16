#!/bin/bash
# Install nagios and nagios plugin in RHEL/CentOS/Fedora

############ Script Credit ################
# This script is forked from http://blog.secaserver.com/2013/04/centos-install-nagios-simple-way/
### Script updated by Hasan T. Emdad <h.t.emdad@gmail.com>
### Date: 12-July-2014 ####################
 
# Disable SElinux
#sed -i.bak 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
#setenforce 0
apt-get update
 
# Nagios requirement
apt-get -y  install perl wget php5-gd apache2 php5 build-essential make openssl  libc6-dev
# Installation directory
installdir=/root/nagios
 
[ ! -d $installdir ] && mkdir -p $installdir
rm -Rf $installdir/*
cd $installdir
 
nagios_latest_url='http://linux.mango.com.bd/nagios/nagios-4.0.7.tar.gz'
nagios_plugin_latest_url='http://linux.mango.com.bd/nagios/nagios-plugins-1.5.tar.gz'
wget $nagios_latest_url
wget $nagios_plugin_latest_url
 
# Nagios
nagios_package=`ls -1 | grep nagios | grep -v plugin`
tar -xzf $nagios_package
cd nagios-*
 
clear
echo "Installing Nagios.."
useradd nagios
./configure
make all
make install
make install-init
make install-commandmode
make install-config
make install-webconf

/etc/init.d/apache2 restart
 
clear
echo "Create .htpasswd for nagios"
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
 
cd $installdir
 
# Nagios Plugin
nagios_plugin_package=`ls -1 | grep nagios-plugin`
tar -xzf $nagios_plugin_package
cd nagios-plugin*
 
clear
echo "Installing Nagios Plugin.."
./configure
make
make install
 
clear
echo "Starting Nagios.."
#chkconfig nagios on
#service nagios start
/etc/init.d/nagios start
 
echo "Staring Apache.."
#service httpd restart
/etc/init.d/apache2 restarts
# chkconfig httpd on
 
# Configure IPtables
#iptables -I INPUT -m tcp -p tcp --dport 80 -j ACCEPT
#service iptables save
clear
 
ip_add=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`


l1="  _____           _        _ _          _ _ "
l2=" |_   _|         | |      | | |        | | |"
l3="   | |  _ __  ___| |_ __ _| | | ___  __| | |"
l4="   | | | '_ \/ __| __/ _  | | |/ _ \/ _  | |"
l5="  _| |_| | | \__ \ || (_| | | |  __/ (_| |_|"
l6=" |_____|_| |_|___/\__\__,_|_|_|\___|\__,_(_)"
                                            
echo "$l1"
echo "$l2"
echo "$l3"
echo "$l4"
echo "$l5"
echo "$l6"
echo "=============================================="                                            
echo "Connect using browser http://$ip_add/nagios/"
echo "=============================================="
echo "username: nagiosadmin"
echo "password: (nagios password)"

