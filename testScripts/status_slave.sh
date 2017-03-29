
#### BigTOP Services Status
GREEN='\033[0;32m'
NC='\033[0m' # No Color
printf ">>>> ${GREEN}Apache BigTop Hadoop-HDFS${NC} Services Status\n"
systemctl -l --type service -all | grep -i hadoop-hdfs-datanode
printf ">>>> ${GREEN}Apache BigTop HADOOP-YARN${NC} Services Status\n"
systemctl -l --type service -all | grep -i hadoop-yarn-nodemanager