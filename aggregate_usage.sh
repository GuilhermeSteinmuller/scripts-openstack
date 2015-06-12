#!/bin/bash

#command nova aggregate-details is suitable for nova version >= 2.22.0


TOTAL_CPU=0
TOTAL_USED_CPU=0
TOTAL_RAM=0
TOTAL_USED_RAM=0

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
	TOTAL_CPU=`expr $TOTAL_CPU + $total_cpu`
	TOTAL_USED_CPU=`expr $TOTAL_USED_CPU + $cpus_used_now`
}

host_ram(){
	local total_ram=$( nova host-describe $(echo $(host $i) | sed "s/'//g" | sed "s/,//g") | grep "(total)" | awk '{ print $8 }')	
	local ram_used_now=$( nova host-describe $(echo $(host $i) | sed "s/'//g" | sed "s/,//g") | grep "(used_now)" | awk '{ print $8 }')	
	echo "Ram (Gb): $(covert_giga $ram_used_now)/$(covert_giga $total_ram)"	
  TOTAL_RAM=`expr $TOTAL_RAM + $total_ram`
  TOTAL_USED_RAM=`expr $TOTAL_USED_RAM + $ram_used_now`
}

host_disk (){
	local total_disk=$( nova host-describe $(echo $(host $i) | sed "s/'//g" | sed "s/,//g") | grep "(total)" | awk '{ print $10 }')
	local disk_used_now=$( nova host-describe $(echo $(host $i) | sed "s/'//g" | sed "s/,//g") | grep "(used_now)" | awk '{ print $10 }')
	echo "Disk(Gb): $disk_used_now/$total_disk";

}

covert_giga (){
	echo $(bc <<< 'scale=2; '$1'/1024')
}


total_usage_aggregate() {
	echo "Total CPU usage of aggregate: $(bc <<< 'scale=2; (100*'$TOTAL_USED_CPU')/'$TOTAL_CPU'') %"	
	echo "Total RAM usage of aggregate: $(bc <<< 'scale=2; (100*'$TOTAL_USED_RAM')/'$TOTAL_RAM'') %"

}


for i in `aggregate_details $1`; do
      echo "--------------------"
      echo "Host: $(echo $i | sed "s/'//g" | sed "s/,//g")"
      echo "--------------------"
      host_cpu $i;
      host_ram $i;
      host_disk $i; 
      echo ""
done

total_usage_aggregate;





