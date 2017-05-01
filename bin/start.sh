#!/bin/bash
cd `dirname $0`
BIN_DIR=`pwd`
cd ..
DEPLOY_DIR=`pwd`

SERVER_NAME=`basename "$PWD"`

if [ "$1" = "jprofiler" ]; then
   JAVA_OPTS="-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -agentpath:/opt/jprofiler10/bin/linux-x64/libjprofilerti.so=port=8849 $JAVA_OPTS"
fi

JAVA_JMX_OPTS=""
if [ "$1" = "jmx" ]; then
  JAVA_JMX_OPTS=" -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmx -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.password.file=../conf/jmx/jmxremote.password -Dcom.sun.management.jmxremote.access.file=../conf/jmx/jmxremote.access"
fi

JAVA_MEM_OPTS=""
BITS=`java -version 2>&1 | grep -i 64-bit`
if [ -n "$BITS" ]; then
    JAVA_MEM_OPTS=" -server -Xmx512m -Xms512m -Xmn128m -Xss256k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "
else
    JAVA_MEM_OPTS=" -server -Xms512m -Xmx512m -XX:PermSize=128m -XX:SurvivorRatio=2 -XX:+UseParallelGC "
fi

export JAVA_OPTS

nohup java $JAVA_OPTS $JAVA_JMX_OPTS $JAVA_MEM_OPTS -jar /usr/local/jetty9/start.jar jetty.base=$DEPLOY_DIR &

