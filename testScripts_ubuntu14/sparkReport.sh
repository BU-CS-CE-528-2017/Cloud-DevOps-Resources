#!/bin/bash

#spark test extraction:
sparkTime="$(cat sparkReport.txt | grep -o took.*s)econds"
sparkPi=$(cat sparkReport.txt | grep "Pi is roughly")
sparkSamples=1000

echo "Spark Test Job $sparkTime"
echo "Total Samples = $sparkSamples"
echo $sparkPi
