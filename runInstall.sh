#!/bin/bash
apt update
apt install ansible
ansible-playbook playbook.yml -i localhost, -e user_name=alexander -e user_password=password
