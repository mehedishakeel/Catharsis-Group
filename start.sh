#!/bin/bash



# for optimize setting use following
export CATALINA_OPTS="-server -noverify -Xms5G -Xmx5G"

# sets the maximum size of the Metaspace.
export CATALINA_OPTS="${CATALINA_OPTS} -XX:MaxMetaspaceSize=2G"


# ----------  GC configuration for production env ---------------
# remove unused classes dynamially created by groovy, This is optimum setting for GC.
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled"

# take the  control of GC, should be active when 70% mem is occupied
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70"

#  Enables GC of the young generation before each full GC.
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+ScavengeBeforeFullGC -XX:+CMSScavengeBeforeRemark"

#  Let's log somewhere and see how well GC is working...
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+PrintGCDateStamps -verbose:gc -XX:+PrintGCDetails -Xloggc:/tmp/gc.log"

# ----------  end GC configuration ----------------
export CATALINA_OPTS="${CATALINA_OPTS} -Djava.net.preferIPv4Stack=true"

export tc="/dw/tomcat8"
cd $tc/bin/
./catalina.sh stop
killall -9 java

cd $tc/work/
rm -rf Catalina

cd $tc/bin/
./catalina.sh start
tail -f ../logs/catalina.out
