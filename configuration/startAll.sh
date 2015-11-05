#!/bin/bash

CWD=`pwd`

source ~/.topology
source hosts
source routers.with_costs
source helperFunctions

# ROUTER_HOST_PAIRS contains 'tuples' of
#  router-hosts pair names/prefixes. There can be 
#  duplicate routers but not hosts
echo "Start nfd on routers

started_nfd=()
for s in "${ROUTER_HOST_PAIRS[@]}" 
do
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}
  HOST=${pair_info[1]}
  ADDRESS=${pair_info[3]}
  echo "nfd: $ROUTER, $HOST"
  # array_contains defined in helperFunctions
  if ! array_contains $started_nfd $ROUTER
  then
    # start nfd on ROUTER
    ssh ${!ROUTER} "cd $CWD ; ./start_nfd.sh ./NFD_OUTPUT/$ROUTER.OUTPUT"
    started_nfd+=("$ROUTER")
  fi
  # start nfd on HOST
  ssh ${!HOST} "cd $CWD ; ./start_nfd.sh ./NFD_OUTPUT/$HOST.OUTPUT"

done


echo "Sleep so nlsr and ndnpingserver will be able to start"
sleep 10

# start ndnpingserver on all of the routers
echo "start ndnpingserver on routers"
echo ${ROUTER_CONFIG}
for s in "${ROUTER_CONFIG[@]}"
do
  router_info=(${s//:/ })
  HOST=${router_info[5]}
  PREFIX=${router_info[3]}
  NAME=${router_info[0]}
  echo "NAME:${NAME} HOST:${HOST} PREFIX:${PREFIX}"
  ssh ${!HOST} "nohup ndnpingserver ${PREFIX} > /dev/null 2>&1 &"
done

# start nlsr on all of the routers
echo "start nlsr on routers"
echo ${ROUTER_CONFIG}
for s in "${ROUTER_CONFIG[@]}"
do
  router_info=(${s//:/ })
  HOST=${router_info[5]}
  NAME=${router_info[0]}
  echo "startAll.sh, nlsr: $NAME $HOST"
  ssh ${!HOST} "mkdir -p /tmp/log/ndn/nlsr/$NAME; mkdir -p /tmp/lib/ndn/nlsr/$NAME"
  #ssh ${!HOST} "cd $CWD ; nohup nlsr -f ./NLSR_CONF/$NAME.conf > ./NLSR_OUTPUT/$NAME.OUTPUT 2>&1 &"
  ssh ${!HOST} "cd $CWD ; nohup ./start_nlsr.sh $NAME > ./NLSR_OUTPUT/$NAME.start_nlsr.out 2>&1 &"

done
