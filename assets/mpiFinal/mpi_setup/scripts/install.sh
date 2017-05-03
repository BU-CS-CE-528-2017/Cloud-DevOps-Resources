#!/bin/bash
source $DEPLOYMENT_HOME/deployment-properties.sh

#Vars
masterIp=$cons3rt_fap_deployment_machine_host1_cons3rt_net_internalIp
slaveOneIp=$cons3rt_fap_deployment_machine_host2_cons3rt_net_internalIp
salveTwoIp=$cons3rt_fap_deployment_machine_host3_cons3rt_net_internalIp
myIp=$(ifconfig eth0 | grep 'inet addr:172' | cut -d ':' -f 2 | awk '{ print $1 }')

echo "$masterIp mpi-master" >> '/etc/hosts'
echo "$slaveOneIp mpi-slave-1" >> '/etc/hosts'
echo "$slaveTwoIp mpi-slave-2" >> '/etc/hosts'

#change hostname to appropriate value
if [ "$myIp" = "$masterIp" ]
then
    echo "mpi-master" > '/etc/hostname'
fi
if [ "$myIp" = "$slaveOneIp" ]
then
    echo "mpi-slave-1" > '/etc/hostname'
fi
if [ "$myIp" = "$slaveTwoIp" ]
then
    echo "mpi-slave-2" > '/etc/hostname'
fi