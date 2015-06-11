#!/bin/bash

#command nova aggregate-details is suitable for nova version >= 2.22.0


#Return the details of a specifc aggregate
aggregate_details () {
	nova aggregate-details $1 | grep -v ^+ | grep -v ^"| Id |" | awk -F\| '{ print $5 }'

}


host_details(){
	local host=$(echo $i | sed "s/'//g" | sed "s/,//g")
	local total_cpu=$( nova host-describe $(echo $host | sed "s/'//g" | sed "s/,//g") | grep "(total)" | awk '{ print $6 }')
	local cpus_used_now=$( nova host-describe $(echo $host | sed "s/'//g" | sed "s/,//g") | grep "(used_now)" | awk '{ print $6 }')
	echo "Host: $(echo $i | sed "s/'//g" | sed "s/,//g")"
	echo -e "CPU: $cpus_used_now/$total_cpu\n";
	
}


for i in `aggregate_details $1`; do
      host_details $i;
done

