spark-submit --class org.apache.spark.examples.SparkPi  $1 /usr/lib/spark/lib/spark-examples.jar 10

#spark-submit --class org.apache.spark.examples.SparkPi \
#    --master yarn \
#    --deploy-mode cluster \
#    --driver-memory 4g \
#    --executor-memory 2g \
#    --executor-cores 1 \
#    --queue thequeue \
#    /usr/lib/spark/lib/spark-examples*.jar \
#    10
