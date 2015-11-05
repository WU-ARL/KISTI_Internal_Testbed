#!/bin/bash

source ~/.topology
source hosts
source helperFunctions

CWD=`pwd`

killed_nfd=()
for s in "${ROUTER_HOST_PAIRS[@]}" 
do
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}
  HOST=${pair_info[1]}
  
  #echo "$ROUTER, $HOST"
  echo "$ROUTER"

  # array_contains defined in helperFunctions
  ssh ${!ROUTER} "killall nfdstat_c"
  #sshpass -e ssh -t ${!HOST} "killall nfd" 
done

#echo "sleep 10 to give nfd from clients and servers to dump gmon.out if they are. Then rtr can be the last"
#sleep 10

