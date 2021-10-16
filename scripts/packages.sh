#!/bin/bash
yum update -y

echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf

# need it to download other files from Internet
yum install -y wget git

# Force logs rotate and remove old logs
/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old
/bin/rm -rf /var/log/anaconda

# Truncate the audit logs
#/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/grubby

# Remove udev persistent rules
/bin/rm -f /etc/udev/rules.d/70*

# Remove mac address and uuids from any interface
/bin/sed -i '/^(HWADDR|UUID)=/d' /etc/sysconfig/network-scripts/ifcfg-*

# Clean /tmp
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*

# /bin/rm -f /root/
# Remove ssh keys
/bin/rm -f /etc/ssh/*key*

# Remove root's SSH history and other cruft
/usr/bin/sed -i "s%#PermitRootLogin yes%PermitRootLogin no%g" "/etc/ssh/sshd_config"
/bin/rm -rf ~root/.ssh/
/bin/rm -f ~root/anaconda-ks.cfg

# Remove root's and users history
/bin/rm -f ~root/.bash_history
/bin/rm -f /home/*/.bash_history
unset HISTFILE
