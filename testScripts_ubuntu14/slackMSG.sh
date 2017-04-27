#!/bin/bash
source $DEPLOYMENT_HOME/deployment-properties.sh

#number of machines:
numVMs=$cons3rt_fap_deployment_numMachines
runID=$cons3rt_deploymentRun_id
numSlaves=$(($numVMs-1))
linkToVM=https://www.cons3rt.com/ui/#/runs/$runID

curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"The Hadoop + Slack Cluster has been deployed | 1 master/$numSlaves | $linkToVM\", \"attachments\":[{\"text\":\"$(./hadoopReport.sh;./sparkReport.sh)\"}]}" \
https://hooks.slack.com/services/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
