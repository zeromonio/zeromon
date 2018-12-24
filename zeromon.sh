#!/bin/bash

# More information can be found at:
# https://zeromon.io/
# https://github.com/ericoc/zeromon

# systemd will execute this script once upon the first boot after a Zeromon Amazon Machine Image (AMI) deployment

# Install Ansible
apt update &&
apt -y install ansible &&

# Configure Ansible for local use
mkdir /tmp/ansible_{local,remote} &&
cat > /etc/ansible/ansible.cfg <<'EOF'
[defaults]
remote_tmp=/tmp/ansible_remote
local_tmp=/tmp/ansible_local
retry_files_enabled=False
ansible_managed=ANSIBLE MANAGED / see https://github.com/ericoc/zeromon for more information
EOF

# Clone the Zeromon Zabbix setup repository locally and run its playbook
git clone https://github.com/ericoc/zeromon.git /usr/local/src/zeromon &&
ansible-playbook -i /usr/local/src/zeromon/hosts /usr/local/src/zeromon/setup.yaml &&

# Append a line to this file just to make it more presentable to users
echo >> /root/zabbix_admin_password &&

# Set up instructions for the root user telling them how to log in to the Zabbix web interface
cat /usr/local/src/zeromon/root.profile > /root/.profile &&
cat /usr/local/src/zeromon/zeromon.prompt > /root/.zeromon &&

# Disable the systemd service which executed this script in order to prevent it from executing multiple times
systemctl disable zeromon
