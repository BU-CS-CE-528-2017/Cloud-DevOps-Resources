#!/bin/bash


SIZE=10000
NUM_MAPS=100
NUM_REDUCES=100
IN_DIR=in_dir
OUT_DIR=out_dir
hadoop fs -rm -r -skipTrash ${IN_DIR} || true
hadoop fs -rm -r -skipTrash ${OUT_DIR} || true
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples-2*.jar teragen ${SIZE} ${IN_DIR}
sleep 5
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples-2*.jar terasort ${IN_DIR} ${OUT_DIR}

#hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples-2*.jar pi 10 100
