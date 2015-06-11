#!/bin/bash

#command nova aggregate-details is suitable for nova version >= 2.22.0


#Return the details of a specifc aggregate
aggregate_details () {
	nova aggregate-details $1 | grep -v ^+ | grep -v ^"| Id |" | awk -F\| '{ print $5 }'

}

host (){
    echo $1 | sed "s/'//g" | sed "s/,//g"
}

host_cpu(){	
	local total_cpu=$( nova host-describe $(echo $(host $i) | sed "s/'//g" | sed "s/,//g") | grep "(total)" | awk '{ print $6 }')
	local cpus_used_now=$( nova host-describe $(echo $(host $i) | sed "s/'//g" | sed "s/,//g") | grep "(used_now)" | awk '{ print $6 }')
	echo "CPU: $cpus_used_now/$total_cpu";
	
}

host_ram(){
	local total_ram=$( nova host-describe $(echo $(host $i) | sed "s/'//g" | sed "s/,//g") | grep "(total)" | awk '{ print $8 }')	
	local ram_used_now=$( nova host-describe $(echo $(host $i) | sed "s/'//g" | sed "s/,//g") | grep "(used_now)" | awk '{ print $8 }')	
	echo "Ram: $(covert_giga $ram_used_now)/$(covert_giga $total_ram)"	

}

covert_giga (){
	echo $(bc <<< 'scale=2; '$1'/1024')
}


for i in `aggregate_details $1`; do
      echo "Host: $(echo $i | sed "s/'//g" | sed "s/,//g")"
      host_cpu $i;
      host_ram $i;
      echo ""
done

