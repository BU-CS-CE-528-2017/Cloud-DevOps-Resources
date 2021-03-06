
#### BigTOP Services Status
GREEN='\033[0;32m'
NC='\033[0m' # No Color

printf ">>>> ${GREEN}Apache BigTop yarn node Status${NC}\n"
sudo -u yarn yarn rmadmin -refreshNodes
sudo -u yarn yarn node -list

printf ">>>> ${GREEN}Apache BigTop yarn hdfs Status${NC}\n"
sudo -u hdfs hdfs dfsadmin -report
sudo -u hdfs hdfs dfsadmin -printTopology
