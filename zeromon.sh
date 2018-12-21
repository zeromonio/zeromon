#!/bin/bash
apt update &&
apt -y install ansible &&
git clone https://github.com/ericoc/zeromon.git /usr/local/src/zeromon &&
ansible-playbook /usr/local/src/zeromon/setup.yaml &&
echo >> /root/zabbix_admin_password
