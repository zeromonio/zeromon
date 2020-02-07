# Zeromon Build Documentation

The following technical information is simply a reference for any one who may be curious.
We create the Zeromon Amazon Machine Image and DigitalOcean Marketplace Droplet snapshot on top of the respective vendor [Ubuntu 18.04 LTS](https://www.ubuntu.com/) images.

_Note: The details below do not apply to Linode. Zeromon on Linode uses a Linode-provided Ubuntu 18.04 LTS image with a Linode StackScript._

## Preparation

The image "build" process is actually incredibly simple since we can place a [cloud-init](https://cloudinit.readthedocs.io/en/latest/) configuration file after updating the base image software; like so...

Update everything:

```
sudo apt update && sudo apt -y upgrade
```

Place the [`cloud-config`](cloud-config) script from this repository at `/etc/cloud/cloud.cfg.d/99_zeromon.cfg`:

```
sudo wget -q https://raw.githubusercontent.com/zeromonio/zeromon/master/cloud-config -O /etc/cloud/cloud.cfg.d/99_zeromon.cfg
```

And finally, we remove the existing SSH host keys as well as our authorized SSH keys from the `root` (and `ubuntu` on AWS) user accounts.
They are replaced with the users own SSH keys by the vendor upon first launch of every deployed instance.
We also clear various logs and `.bash_history` files.

```
sudo rm -rf /etc/ssh/ssh_host_* /root/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys /var/log/unattended-upgrades /var/log/cloud-init*log
sudo truncate --size 0 /var/log/{alternatives,auth,dpkg,kern,mail}.log /home/ubuntu/.bash_history /root/.bash_history
```

## First Boot

The `cloud-config` script runs upon the first boot of a newly launched instance.
You can even check the progress of `cloud-init` if you log in quickly upon the first boot of a newly deployed instance and follow along with its log file:

```
tail -F /var/log/cloud-init-output-zeromon.log
```

The `cloud-config` script completes the following steps:
- Installs and configures [Ansible](https://www.ansible.com/)
- Clones this GitHub repository
- Runs the [`setup.yaml`](setup.yaml) Ansible playbook from the cloned copy of the repository

The following software is installed (via [apt](https://help.ubuntu.com/lts/serverguide/apt.html.en)) and configured by the Ansible playbook/roles upon first boot:

- [Zabbix 4.x](https://www.zabbix.com/)
- [Apache 2.4](https://httpd.apache.org/)
- [PHP 7.2](https://secure.php.net/)
- [MariaDB 10.1](https://mariadb.org/)
- [Postfix](http://www.postfix.org/)
- [UFW](https://help.ubuntu.com/community/UFW) ("Uncomplicated Firewall")
- [Certbot](https://certbot.eff.org/)

Additionally, a few other steps are done by the Ansible playbook, such as placing instructions in the `root` user prompt on how to log in to the Zabbix web user interface.

### Security

A number of steps were taken within the Ansible roles in this repository to secure the installation of Zabbix and each instance as a whole:
- Default anonymous MySQL user accounts are removed
- Random passwords are generated for both the `zabbix` and `root` MySQL user accounts
- A random password is generated for the Zabbix `Admin` web user
- No "Guest" access is allowed to the Zabbix web user interface
- Configuration changes are made to the default web server (Apache) installation which:
    * Avoid "click-jacking"
    * Disable unnecessary modules
    * Prevent exposing the operating system and version number
- The local Zabbix agent (which allows the Zabbix server to monitor itself) is configured to only listen for local network connections
- The e-mail server (Postfix, which allows Zabbix to send alerts/notifications) is configured to only listen for local network connections
- The firewall software (UFW) also rejects all inbound network connections except for those to the following destinations on the server:
    * any on the `lo` interface (`localhost` / `127.0.0.1`)
    * `tcp/10051` (`zabbix-server`)
    * `udp/162` (`snmp-trap`)
    * `tcp/22` (`ssh`)
    * `tcp/80` and `tcp/443` (`http` and `https`)
- The Certbot ACME client is pre-installed allowing users to set up HTTPS with a valid SSL certificate which should be automatically renewed
