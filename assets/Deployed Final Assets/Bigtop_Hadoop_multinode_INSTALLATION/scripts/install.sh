#!/bin/bash
# Created by David Asbjornsson	(3/22/17)
cd /Cloud-DevOps-Resources/testScripts
if [ "$HOSTNAME" = "hadoop-master"]
then
	sudo ./install_bigtop_master.sh
else
	sudo ./install_bigtop_slave.sh bigtop-master
fi