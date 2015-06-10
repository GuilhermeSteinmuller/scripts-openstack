#!/bin/bash




for i in `nova aggregate-details $1 | grep -v ^+ | grep -v ^"| Id |" | awk -F\| '{ print $5 }'`; do 
		nova host-describe $(echo $i | sed "s/'//g" | sed "s/,//g"); 
done

