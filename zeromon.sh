#!/bin/bash

apt update &&
apt -y install ansible &&

mkdir /tmp/ansible_{local,remote} &&
cat > /root/.ansible.cfg <<'EOF'
[defaults]
remote_tmp=/tmp/ansible_remote
local_tmp=/tmp/ansible_local
retry_files_enabled=False
EOF

git clone https://github.com/ericoc/zeromon.git /usr/local/src/zeromon &&
ansible-playbook -i /usr/local/src/zeromon/hosts /usr/local/src/zeromon/setup.yaml &&
echo >> /root/zabbix_admin_password &&

systemctl disable zeromon
