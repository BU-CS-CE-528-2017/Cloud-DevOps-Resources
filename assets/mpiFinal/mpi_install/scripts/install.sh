#!/bin/bash
source $DEPLOYMENT_HOME/deployment-properties.sh


#Variables
masterIp=$cons3rt_fap_deployment_machine_host1_cons3rt_net_internalIp
slaveOneIp=$cons3rt_fap_deployment_machine_host2_cons3rt_net_internalIp

nfsPath=/home/cons3rt/nfs


#Install MPI
apt-get install -y openmpi-bin openmpi-doc libopenmpi-dev


#Create hosts file in nfs direcotry
touch $nfsPath/hosts

echo $masterIp >> $nfsPath/hosts
echo $slaveOneIp >> $nfsPath/hosts

#Copy Example hello world
cp $ASSET_DIR/media/mpi_hello.c $nfsPath

chown -R cons3rt:cons3rt $nfsPath