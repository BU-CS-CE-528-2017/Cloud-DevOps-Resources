#!/bin/bash
# Created by David Asbjornsson	(3/22/17)
########## CONFIGURATION ##########
source $DEPLOYMENT_HOME/deployment-properties.sh

#extract the private ip addresses:
masterIP=$cons3rt_fap_deployment_machine_master_cons3rt_net_internalIp
slaveOneIP=$cons3rt_fap_deployment_machine_slave_1_cons3rt_net_internalIp
slaveTwoIP=$cons3rt_fap_deployment_machine_slave_2_cons3rt_net_internalIp
myIP=$(ifconfig eth0 | grep 'inet addr:172' | cut -d ':' -f 2 | awk '{ print $1 }')

#make sure hostname is linked to private ip address in file /etc/hosts:
echo "$masterIP hadoop-master" >> '/etc/hosts'
echo "$slaveOneIP hadoop-slave-1" >> '/etc/hosts'
echo "$slaveTwoIP hadoop-slave-2" >> '/etc/hosts'

#add these two lines to the file /etc/security/limits.conf:
echo "*              soft    nofile          1000000" >> /etc/security/limits.conf
echo "*              hard   nofile          1000000" >> /etc/security/limits.conf

#install git:
sudo apt-get update
sudo apt-get -y install git

#download essential files
sudo git clone https://github.com/BU-CS-CE-528-2017/Cloud-DevOps-Resources

cd Cloud-DevOps-Resources/testScripts
sudo chmod +x *.sh

#change hostname to appropriate value
if [ "$myIP" = "$masterIP" ]
then
    echo "hadoop-master" > '/etc/hostname'
fi
if [ "$myIP" = "$slaveOneIP" ]
then
    echo "hadoop-slave-1" > '/etc/hostname'
fi
if [ "$myIP" = "$slaveTwoIP" ]
then
    echo "hadoop-slave-2" > '/etc/hostname'
fi