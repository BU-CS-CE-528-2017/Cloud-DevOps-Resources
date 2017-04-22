#!/bin/bash
set -ex
sudo apt-get update

wget https://ci.bigtop.apache.org/view/Packages/job/Bigtop-trunk-packages/COMPONENTS=spark,OS=ubuntu-16.04/lastSuccessfulBuild/artifact/output/spark/*zip*/spark.zip
#wget https://ci.bigtop.apache.org/job/Bigtop-trunk-packages-by-jenkins/COMPONENTS=spark,OS=ubuntu-16.04/lastSuccessfulBuild/artifact/*zip*/archive.zip
unzip archive.zip

cd $PWD/spark
sudo RUNLEVEL=1 dpkg -i spark*.deb
cd ..

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

sudo chmod -R 1777 /tmp
