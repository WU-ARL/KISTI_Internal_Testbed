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
  
  echo "$ROUTER, $HOST"

  # array_contains defined in helperFunctions
  if ! array_contains $killed_nfd $ROUTER
  then
    ssh ${!ROUTER} "killall nfd ; killall start_nlsr.sh; killall nlsr; killall ndnpingserver ; killall nfdstat_c"
    killed_nfd+=("$ROUTER")
  fi
  ssh ${!HOST} "killall nfd  "
  #sshpass -e ssh -t ${!HOST} "killall nfd" 
done

#echo "sleep 10 to give nfd from clients and servers to dump gmon.out if they are. Then rtr can be the last"
#sleep 10

