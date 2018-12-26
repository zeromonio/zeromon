#!/bin/bash

# More information can be found at:
# https://zeromon.io/
# https://github.com/ericoc/zeromon

# systemd will execute this script once upon the first boot after a Zeromon Amazon Machine Image (AMI) deployment

# Clone the Zeromon Zabbix setup repository locally, configure Ansible for local use, and run the playbook
git clone https://github.com/ericoc/zeromon.git /usr/local/src/zeromon &&
mkdir /tmp/ansible_{local,remote} &&
cat /usr/local/src/zeromon/ansible.cfg > /etc/ansible/ansible.cfg &&
ansible-playbook -i /usr/local/src/zeromon/hosts /usr/local/src/zeromon/setup.yaml &&

# Append a line to this file just to make it more presentable to users
echo >> /root/zabbix_admin_password &&

# Set up instructions for the root user telling them how to log in to the Zabbix web interface
cat /usr/local/src/zeromon/root.profile > /root/.profile &&
cat /usr/local/src/zeromon/zeromon.prompt > /root/.zeromon &&

# Disable the systemd service which executed this script in order to prevent it from executing multiple times
systemctl disable zeromon
