export NAMESRV_ADDR=localhost:9876
sh $MQ_HOME/bin/mqnamesrv
sh $MQ_HOME/bin/mqbroker -n localhost:9876
