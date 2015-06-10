#!/bin/bash



echo -e "Statistics of aggregate $1\n"
for i in `nova aggregate-details $1 | grep -v ^+ | grep -v ^"| Id |" | awk -F\| '{ print $5 }'`; do 
		echo "Host: $(echo $i | sed "s/'//g" | sed "s/,//g")"
		total_cpu=$(nova host-describe $(echo $i | sed "s/'//g" | sed "s/,//g") | grep "(total)" | awk '{ print $6 }');
		cpu_used=$(nova host-describe $(echo $i | sed "s/'//g" | sed "s/,//g") | grep "(used_now)" | awk '{ print $6 }'); 
	 	max_cpu_usage=$(nova host-describe $(echo $i | sed "s/'//g" | sed "s/,//g") | grep "(used_max)" | awk '{ print $6 }');
		echo "Total cpu: $total_cpu    Used cpu: $cpu_used      Cpu maximum usage: $max_cpu_usage";
		echo "" 
done

