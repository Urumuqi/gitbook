# java_app.sh 龙老板写的Java程序启动脚本

部署 `xxl-job` JAR 包时，龙老板用到了这个脚本，很棒。脚本代码如下：

将该脚本赋予执行权限，并与`jar`包放到相同目录。

```bash
sudo chmod +x java_app.sh
# start
./java_app.sh start
# restart
./java_app.sh restart
```

从此告别`nohup java -jar xxxx`启动命令. 

```bash
#!/bin/bash
source /etc/profile
source ~/.bashrc

CUR_DIR=`dirname $0`
if [ "." == "$CUR_DIR" ]; then
    CUR_DIR=`pwd`
fi

LOG_DIR=$CUR_DIR/logs
if [ ! -d $LOG_DIR ]; then
    mkdir -p $LOG_DIR
fi

cd $CUR_DIR
JAR_NAME=`ls | grep "\.jar$"`

JAVA_OPT="-Xms256M -Xmx256M -Xmn128M"
JAVA_OPT=$JAVA_OPT" -Xloggc:$LOG_DIR/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps"
#JAVA_OPT=$JAVA_OPT" -javaagent:/usr/local/webserver/jmx-agent/jmx_prometheus_javaagent-0.3.1.jar=9089:/usr/local/webserver/jmx-agent/kafka-0-8-2-pc.yml"
JAVA_OPT=$JAVA_OPT" -server -jar"
JAVA_OPT=$JAVA_OPT" -Djava.security.egd=file:/dev/./urandom"

function stop_app() {
    PID=`ps -ef | grep $JAR_NAME | grep -v grep | grep -v bash | awk '{print $2}'`
    if [ -n "$PID" ]; then
        echo "kill process $PID"
        kill -9 $PID
        echo "$JAR_NAME stopped!"
    else
        echo "process not exist, pass"
    fi
}

function start_app() {
    # JAVA_OPT=$JAVA_OPT" -Denv=$1 -Dapp.id=$2"
    JAVA_ARG=""

    PID=`ps -ef | grep $JAR_NAME | grep -v grep | grep -v bash | awk '{print $2}'`
    if [ -n "$PID" ]; then
        echo "process exist, starting fail!"
        exit 1
    else
        echo "starting $JAR_NAME ..."
        nohup java $JAVA_OPT $JAR_NAME $JAVA_ARG >/dev/null 2>&1 &

        PID=`ps -ef | grep $JAR_NAME | grep -v grep | grep -v bash | awk '{print $2}'`
        echo "$JAR_NAME started! PID: $PID"
    fi
}

function restart_app() {
    stop_app
    start_app
}

if [ "restart" == "$1" ]; then
    restart_app
elif [ "stop" == "$1" ]; then
    stop_app
elif [ "start" == "$1" ]; then
    start_app
else
    echo "No such operation: $1"
fi
```
