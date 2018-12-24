# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

if [ -s "/root/zabbix_admin_password" ]; then
  . ~/.zeromon
fi

mesg n || true
