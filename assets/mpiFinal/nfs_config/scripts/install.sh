#!/bin/bash
source $DEPLOYMENT_HOME/deployment-properties.sh

masterIp=$cons3rt_fap_deployment_machine_host1_cons3rt_net_internalIp

apt-get update

#Setup NFS
nfsPath=/home/cons3rt/nfs
mkdir $nfsPath
chown -R cons3rt:cons3rt $nfsPath


if [ $HOSTNAME = "mpi-master" ]
then
	apt-get install -y nfs-kernel-server
	echo "$nfsPath *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
	exportfs -a
	service nfs-kernel-server restart
else
	apt-get install -y nfs-common
	mount -t nfs $masterIp:$nfsPath $nfsPath
	echo "$masterIp:$nfsPath $nfsPath nfs" >> /etc/fstab
fi