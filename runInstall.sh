#!/bin/bash
apt update
apt install ansible sudo sshpass -y
ansible-playbook playbook.yml -i localhost -e user_name=alexander -e user_password=password -e ansible_ssh_user=alexander -e ansible_ssh_password=password -e ansible_become_method=su
