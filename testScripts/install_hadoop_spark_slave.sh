#!/bin/bash
#install script for hadoop and spark on a master node
set -ex
sudo apt-get update

wget https://ci.bigtop.apache.org/job/Bigtop-1.0.0-deb/BUILD_ENVIRONMENTS=ubuntu-14.04,label=docker-slave-07/lastSuccessfulBuild/artifact/output/spark/*zip*/archive.zip
unzip archive.zip; mv archive/output/spark/*.deb .; rm -rf archive; rm archive.zip

cd $wrk_dir/source
sudo  RUNLEVEL=1 dpkg -i spark*.deb
cd ..

sudo  RUNLEVEL=1 dpkg -i spark*.deb

### Spark configuration
echo "export SPARK_MASTER_IP=$1"  |sudo tee -a /etc/spark/conf/spark-env.sh
sudo chown -R $(whoami):hadoop /etc/spark
cp /etc/spark/conf/spark-defaults.conf.template /etc/spark/conf/spark-defaults.conf
echo "spark.master                     spark://$1:7077" >>/etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.enabled           true" >>/etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.dir               hdfs://$1:8020/directory" >>/etc/spark/conf/spark-defaults.conf
echo "spark.yarn.am.memory             1024m" >>/etc/spark/conf/spark-defaults.conf

cp /etc/spark/conf/log4j.properties.template /etc/spark/conf/log4j.properties
echo "log4j.rootCategory=ERROR, console">>/etc/spark/conf/log4j.properties

sudo service spark-worker start

sudo chmod -R 1777 /tmp
