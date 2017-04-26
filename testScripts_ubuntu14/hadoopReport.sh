#!/bin/bash

#hadoop test extraction:
hadoopPi=$(cat hadoopReport.txt | grep Estimated)
hadoopTime=$(cat hadoopReport.txt | grep "Job Finished")
hadoopMaps=$(cat hadoopReport.txt | grep "Number of Maps")
hadoopSamples=$(cat hadoopReport.txt | grep Samples)

echo "Hadoop Test $hadoopTime"
echo $hadoopMaps
echo $hadoopSamples
echo $hadoopPi
