#!/bin/bash

args=( $@ );
for (( i=0; $i < $# ; i++ ))
do
  [[ "${args[$i]}" =~ --ipaddr= ]] && ipaddr=${args[$i]#*=} && continue
  [[ "${args[$i]}" =~ --port= ]]  && port=${args[$i]#*=} && continue
  [[ "${args[$i]}" =~ --hostheader= ]] && hostheader=${args[$i]#*=} && continue
  [[ "${args[$i]}" =~ --uri= ]] && uri=${args[$i]#*=} && continue
  [[ "${args[$i]}" =~ --returnstring= ]] && returnstring=${args[$i]#*=} && continue
done

curl -s http://${ipaddr}:${port}/${uri} -H "Host: $hostheader" | grep "${returnstring}" > /dev/null

exit $? 
