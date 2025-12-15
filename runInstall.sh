#!/bin/bash
apt update
apt install ansible sudo sshpass -y
#export COUNT_MONITOR=`ls /sys/class/drm/*/status | xargs grep -H "connected" | wc -l`
export COUNT_MONITOR=1
ansible-playbook playbook.yml -i localhost -e user_name=alexander -e user_password=password -e ansible_ssh_user=alexander -e ansible_ssh_password=password -e ansible_become_method=su -e count_monitor=$COUNT_MONITOR
