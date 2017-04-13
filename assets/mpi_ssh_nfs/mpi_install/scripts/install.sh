#!/bin/bash
source $DEPLOYMENT_HOME/deployment-properties.sh

masterIp=$cons3rt_fap_deployment_machine_master_cons3rt_net_internalIp

#Custom Properties to setup ssh
# masterUsername=cons3rt
# masterPassword=TMEroot!!
# slaveOneUsername=cons3rt
# slaveOnePassword=TMEroot!!
# slaveTwoUsername=cons3rt
# slaveTwoPassword=TMEroot!!

apt-get update

apt-get install -y expect

#Install MPI
apt-get install -y openmpi-bin openmpi-doc libopenmpi-dev

#Setup ssh
ssh-keygen -t rsa -N "" -f my_id_rsa

if [ $HOSTNAME = "mpi-master" ] ; then
	spawn ssh-copy-id -i ~/.ssh/my_id_rsa.pub mpi-slave1
	expect "assword:"
	send $slaveOnePassword
	interact
	spawn ssh-copy-id -i ~/.ssh/my_id_rsa.pub mpi-slave2
	expect "assword:"
	send $slaveTwoPassword
	interact
else
	spawn ssh-copy-id -i ~/.ssh/my_id_rsa.pub mpi-master
	expect "assword:"
	send $masterPassword
	interact
if

eval `ssh-agent`
ssh-add ~/.ssh/my_id_rsa

#Setup NFS
mkdir nfs
if [ $HOSTNAME = "mpi-master" ] ; then
	apt-get install -y nfs-kernel-server
	echo "$HOME/nfs *(rw,sync,no_root_squash,no_subtree_check)"
	exportfs -a
	service nfs-kernel-server restart
else
	apt-get install -y nfs-common
	mount -t nfs mpi-master:/home/$masterUsername/nfs $HOME/nfs
	echo mpi-master:/home/$masterUsername/nfs $HOME/nfs
if


service nfs-kernel-server restart