#!/bin/bash

get_user(){
	user_id=$(nova show $1 | grep "user_id" | awk '{print $4}')
	echo "$(openstack user list | grep $user_id | awk '{print $4}')"
}

get_vm_name(){
	echo "$(nova show $1 | grep ^"| name" | awk '{print $4}')"
}

get_host(){
	echo "$(nova show $1 | grep "OS-EXT-SRV-ATTR:hypervisor_hostname" | awk '{print $4}')"
}

echo "$(get_vm_name $1) | $(get_host $1) | $(get_user $1)"

