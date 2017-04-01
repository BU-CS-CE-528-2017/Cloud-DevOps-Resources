#!/bin/bash
set -ex
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y  ppa:openjdk-r/ppa
sudo apt-get update

sudo apt-get install -y python wget openssl liblzo2-2 openjdk-8-jdk unzip netcat-openbsd apt-utils openssh-server libsnappy1 libsnappy-java
sudo wget -O- http://archive.apache.org/dist/bigtop/bigtop-1.1.0/repos/GPG-KEY-bigtop | sudo apt-key add -
sudo apt-get update

sudo wget -O /etc/apt/sources.list.d/bigtop-1.1.0.list  http://www.apache.org/dist/bigtop/bigtop-1.1.0/repos/trusty/bigtop.list

sudo apt-get update

wget https://ci.bigtop.apache.org/job/Bigtop-1.1.0/BUILD_ENVIRONMENTS=ubuntu-14.04,label=docker-slave/lastSuccessfulBuild/artifact/*zip*/archive.zip
unzip archive.zip; mv archive/output/spark/*.deb .; rm -rf archive; rm archive.zip

sudo RUNLEVEL=1 apt-get install -y hadoop hadoop-client hadoop-hdfs hadoop-yarn* hadoop-mapred* hadoop-conf* libhdfs_* 

sudo  RUNLEVEL=1 dpkg -i spark*.deb 

export HADOOP_PREFIX=/usr/lib/hadoop
export JAVA_HOME=`sudo find /usr/ -name java-8-openjdk-*`
export HADOOP_CONF_DIR=/etc/hadoop/conf

echo "export JAVA_HOME=`sudo find /usr/ -name java-8-openjdk-*`" | sudo tee -a  /etc/environment $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_CONF_DIR=/etc/hadoop/conf"  | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_PREFIX=/usr/lib/hadoop"  | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec" | sudo tee -a  $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_LOGS=/usr/lib/hadoop/logs"  | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_COMMON_HOME=/usr/lib/hadoop" | sudo tee -a  $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_HDFS_HOME=/usr/lib/hadoop-hdfs" | sudo tee -a  $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce" | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_YARN_HOME=/usr/lib/hadoop-yarn" | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh

sudo sed -i s/localhost/$HOSTNAME/ /etc/hadoop/conf/core-site.xml
sudo chown -R $USER:hadoop /usr/lib/hadoop*
sudo chown -R hdfs:hadoop /var/log/hadoop-hdfs*
sudo chown -R yarn:hadoop /var/log/hadoop-yarn*
sudo chown -R mapred:hadoop /var/log/hadoop-mapred*
sudo chown -R $USER:hadoop /etc/hadoop
./update-conf.sh $HOSTNAME $HOSTNAME

### master node onlly
sudo -u hdfs hdfs namenode -format -force
sudo rm -rf /var/lib/hadoop-hdfs/cache/hdfs/dfs/data
sudo service hadoop-hdfs-namenode start

sudo -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate
sudo -u hdfs hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn

sudo service hadoop-yarn-resourcemanager start
#sudo service hadoop-yarn-nodemanager start
sudo service hadoop-mapreduce-historyserver start
#sudo service hadoop-yarn-timelineserver restart

#sudo -u hdfs hadoop fs -mkdir -p /user/$USER
#sudo -u hdfs hadoop fs -chown $USER /user/$USER

### Spark configuration 
echo "export SPARK_MASTER_IP=`hostname`"  |sudo tee -a /etc/spark/conf/spark-env.sh
sudo chown -R $USER:hadoop /etc/spark
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
sudo -u hdfs hdfs dfs -chown -R $USER:hadoop /var/log/spark

#for x in `cd /etc/init.d ; ls spark-*` ; do sudo service $x start ; done
sudo service spark-master start
sudo service spark-history-server start
