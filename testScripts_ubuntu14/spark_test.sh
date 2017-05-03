spark-submit --class org.apache.spark.examples.SparkPi --master yarn://hadoop-master:7077 --deploy-mode client --driver-memory 1g --executor-memory 1g /usr/lib/spark/lib/spark-examples-*.jar 1000
