#!/bin/bash

source ~/.topology
source hosts
source helperFunctions

CWD=`pwd`

for s in "${ROUTER_HOST_PAIRS[@]}" 
do
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}
  HOST=${pair_info[1]}
  
  echo "$ROUTER, $HOST"

  # array_contains defined in helperFunctions
  ssh ${!ROUTER} "killall start_nlsr.sh; killall nlsr; "
done

