#!/bin/bash
source $DEPLOYMENT_HOME/deployment-properties.sh

masterIp=$cons3rt_fap_deployment_machine_host1_cons3rt_net_internalIp
slaveOneIp=$cons3rt_fap_deployment_machine_host2_cons3rt_net_internalIp

#User ssh create
sshPath=/home/cons3rt/.ssh
mkdir -p $sshPath
chmod 700 $sshPath
touch $sshPath/authorized_keys
chmod 600 ${sshPath}/authorized_keys

#Known Hosts
touch $sshPath/known_hosts
if [ $HOSTNAME = "mpi-master" ] ; then
	echo "$slaveOneIp $(cat ${ASSET_DIR}/media/ssh-key.pub)" >> ${sshPath}/known_hosts
else
	echo "$masterIp $(cat ${ASSET_DIR}/media/ssh-key.pub)" >> ${sshPath}/known_hosts
fi

#Authorized Keys
if [ $HOSTNAME = "mpi-master" ] ; then
	echo "$(cat ${ASSET_DIR}/media/ssh-key.pub)" >> ${sshPath}/authorized_keys
else
	echo "$(cat ${ASSET_DIR}/media/ssh-key.pub)" >> ${sshPath}/authorized_keys
fi

#Copy public and private keys from media file to user .ssh
cp ${ASSET_DIR}/media/ssh-key.pub ${sshPath}/id_rsa.pub
cp ${ASSET_DIR}/media/ssh-key ${sshPath}/id_rsa

#Copy public and private keys from media file to host ssh
cp ${ASSET_DIR}/media/ssh-key.pub /etc/ssh/ssh_host_rsa_key.pub
cp ${ASSET_DIR}/media/ssh-key /etc/ssh/ssh_host_rsa_key

chmod 600 ${sshPath}/id_rsa

chown -R cons3rt:cons3rt $sshPath