#!/bin/bash
source $DEPLOYMENT_HOME/deployment-properties.sh

#Vars
masterIp=$cons3rt_fap_deployment_machine_master_cons3rt_net_internalIp
slaveOneIp=$cons3rt_fap_deployment_machine_slave_1_cons3rt_net_internalIp
salveTwoIp=$cons3rt_fap_deployment_machine_slave_2_cons3rt_net_internalIp
myIP=$(ifconfig eth0 | grep 'inet addr:172' | cut -d ':' -f 2 | awk '{ print $1 }')

echo "$masterIP mpi-master" >> '/etc/hosts'
echo "$slaveOneIP mpi-slave-1" >> '/etc/hosts'
echo "$slaveTwoIP mpi-slave-2" >> '/etc/hosts'

#change hostname to appropriate value
if [ "$myIP" = "$masterIP" ]
then
    echo "mpi-master" > '/etc/hostname'
fi
if [ "$myIP" = "$slaveOneIP" ]
then
    echo "mpi-slave-1" > '/etc/hostname'
fi
if [ "$myIP" = "$slaveTwoIP" ]
then
    echo "mpi-slave-2" > '/etc/hostname'
fi