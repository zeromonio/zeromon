# Zeromon

[Zeromon](https://zeromon.io/) provides a pre-built Zabbix installation via an Amazon Machine Image (AMI) on Amazon Web Services (AWS).
The AMI (`ami-00a28cc59e938e179`) is built using this repository.

### Usage

After deployment of the AMI, you can simply visit the IP address or DNS name of your new EC2 instance.
You will be able to log in to the Zabbix web interface with the default user name of `Admin`.
The password for the Zabbix `Admin` web user can be found by connecting to your EC2 instance via SSH and reading the contents of the file `/root/zabbix_admin_password`.

### Pricing

The cost for usage of this AMI is $0.05 USD per hour (or basically, $36.00 USD per month) for all instance types in all regions.
Unfortunately, the AMI is not currently available within the Amazon GovCloud region at this time.

We also offer a 7-day 100% money-back guarantee.

### Support

Any questions or concerns can be sent to support@zeromon.io

---

### Technical Details

None of this is super critical information, but is mostly for reference to any one who happens to be curious.

#### Software

Per the [Ansible](https://www.ansible.com/) automation within this repository, the following software is installed upon the first boot of the prepared AMI:

- [Ubuntu 18.04 LTS](https://www.ubuntu.com/)
- [Zabbix 4.x](https://www.zabbix.com/)
- [Apache 2.4](https://httpd.apache.org/)
- [PHP 7.2](https://secure.php.net/)
- [MariaDB](https://mariadb.org/)

#### Preparation

In order to create the Zeromon AMI, I have been building it from the official AWS Ubuntu 18.04 LTS AMI (`ami-0ac019f4fcb7cb7e6`).
Once I create an EC2 instance using this official Ubuntu AMI, I run the following commands to prepare and create an AMI it:

```
cd /usr/local/bin/ && wget https://raw.githubusercontent.com/ericoc/zeromon/master/zeromon.sh && chmod +x zeromon.sh &&
cd /lib/systemd/system/ && wget https://raw.githubusercontent.com/ericoc/zeromon/master/zeromon.service && systemctl enable zeromon &&
rm /root/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys && history -c
```

The above steps do the following:
- Place a script (`[zeromon.sh](zeromn.sh)`) within `/usr/local/bin/` that will:
 * Install and configure Ansible
 * Clone this Ansible repository
 * Execute this Ansible playbook (`[setup.yaml](setup.yaml)`)
- Set up a `systemd` service (`[zeromon.sh](zeromon.sh)`) to execute the script that was just placed (`/usr/local/bin/zeromon.sh`) upon the servers next boot
- Remove all SSH authorized keys from the root and `ubuntu` user accounts as well as clear the root user account bash history

I then create an AMI from the running EC2 instance which I have just prepared with the above commands..
Upon the creation and boot of a second new EC2 instance using the AMI that was just created, `systemd` should execute `/usr/local/bin/zeromon.sh` which will install and configure Ansible before cloning this repository and executing its playbook to completely set up a working Zabbix installation.
