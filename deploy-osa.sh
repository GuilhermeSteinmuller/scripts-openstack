#!/bin/bash

# Clone osa based on the tag 
git clone -b $1 https://git.openstack.org/openstack/openstack-ansible 

mv openstack-ansible /opt/

# Change to osa dir
cd /opt/openstack-ansible

# bootstrap ansible
./scripts/bootstrap-ansible.sh

# bootstrap aio
./scripts/bootstrap-aio.sh

# install openstack
cd /opt/openstack-ansible/playbooks
openstack-ansible setup-everything.yml
