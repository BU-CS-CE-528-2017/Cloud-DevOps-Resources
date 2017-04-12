#!/bin/bash
set -ex
sudo apt-get update

wrk_dir=$PWD
if [ ! -d source  ] ; then
mkdir source; cd $_

wget https://ci.bigtop.apache.org/job/Bigtop-1.1.0/BUILD_ENVIRONMENTS=ubuntu-14.04,label=docker-slave/lastSuccessfulBuild/artifact/*zip*/archive.zip
unzip archive.zip; mv archive/output/spark/*.deb .; rm -rf archive; rm archive.zip

cd $wrk_dir/source
sudo  RUNLEVEL=1 dpkg -i spark*.deb
cd ..

### Spark configuration
echo "export SPARK_MASTER_IP=`hostname`"  |sudo tee -a /etc/spark/conf/spark-env.sh
sudo chown -R $(whoami):hadoop /etc/spark
cp /etc/spark/conf/spark-defaults.conf.template /etc/spark/conf/spark-defaults.conf
echo "spark.master                     spark://$(hostname):7077" >>/etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.enabled           true" >>/etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.dir               hdfs://$(hostname):8020/directory" >>/etc/spark/conf/spark-defaults.conf
echo "spark.yarn.am.memory             1024m" >>/etc/spark/conf/spark-defaults.conf

cp /etc/spark/conf/log4j.properties.template /etc/spark/conf/log4j.properties
echo "log4j.rootCategory=ERROR, console">>/etc/spark/conf/log4j.properties

sudo -u hdfs hadoop fs -mkdir -p /directory
sudo -u hdfs hadoop fs -chown -R spark:hadoop /directory
sudo -u hdfs hdfs dfs -chmod -R 1777 /directory
sudo -u hdfs hdfs dfs -mkdir -p  /var/log/spark/apps
sudo -u hdfs hdfs dfs -chown -R $(whoami):hadoop /var/log/spark

#for x in `cd /etc/init.d ; ls spark-*` ; do sudo service $x start ; done
sudo service spark-master start
sudo service spark-history-server start
