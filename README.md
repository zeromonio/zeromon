# Zeromon

[Zeromon](https://zeromon.io/) provides a pre-built [Zabbix](https://www.zabbix.com/) installation via an Amazon Machine Image ([AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)) on Amazon Web Services ([AWS](https://aws.amazon.com/)).
The Zeromon AMI is built via and dependent upon this Git repository.

### Usage

After deployment of our AMI, the automation from this repository will run and take approximately 2-3 minutes.
You can verify that the process is complete by simply visiting the IP address or DNS name of your new EC2 instance in a web browser.
You should see the Zabbix log-in screen asking for a user name and password once it is ready.
To log in to your Zabbix web interface, you will need to SSH to your EC2 instance as the `ubuntu` user with the SSH key that you used when deploying via AWS.
Once logged in via SSH as the `ubuntu` user, simply run `sudo -i` for instructions that include the user name (`Admin`) and randomly generated password which you will use to log in to your Zabbix web interface.

### Pricing

The cost for usage of this AMI software is $0.05 USD per hour (or basically, $36.00 USD per month) for all instance types in all regions, in addition to the EC2 pricing itself.

We also offer a 7-day 100% money-back guarantee.

#### Instance Type

Note that $0.05/hour is billed on top of the AWS instance pricing which is calculated separately and dependent upon Amazon based on the region and instance type.
We generally recommend starting with a `t3.medium` instance type, but you may be able to use a `t3.small` for a smaller environment.
However, a `t3.large` (or bigger) may be necessary depending upon the number of instances that you plan to monitor and pollers you configure within the Zabbix server.

You may want to experiment with other instance types as well to determine what works best for you and your environment - please feel free to let us know!

### Support

Any questions or concerns can be sent to support@zeromon.io and we will do our best to help you out!

Unfortunately, the AMI is not currently available within the Amazon GovCloud region at this time.

---

### Technical Details

The following technical information is simply a reference for any one who may be curious about how the AMI is built.

#### Software

Per the automation within this repository, the following software is installed upon the first boot of an EC2 instance launched with our AMI:

- [Ansible](https://www.ansible.com/)
- [Ubuntu 18.04 LTS](https://www.ubuntu.com/)
- [Zabbix 4.x](https://www.zabbix.com/)
- [Apache 2.4](https://httpd.apache.org/)
- [PHP 7.2](https://secure.php.net/)
- [MariaDB 10.1](https://mariadb.org/)
- [Postfix](http://www.postfix.org/)

##### Security

A number of steps were taken within the playbook in this repository to secure the installation of Zabbix and the server as a whole:
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

#### Preparation

In order to create the Zeromon AMI, we have been building it from the official AWS Ubuntu 18.04 LTS AMI and using [cloud-init](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-ami-basics.html#amazon-linux-cloud-init).
Once an EC2 instance is launched using this official Ubuntu AMI, we only do a few steps to prepare the creation of our own image:

Update everything:

```
sudo apt update && sudo apt -y upgrade
```

Place the [`cloud-config`](cloud-config) script from this repository at `/etc/cloud/cloud.cfg.d/99_zeromon.cfg`:

```
sudo wget -q https://raw.githubusercontent.com/ericoc/zeromon/master/cloud-config -O /etc/cloud/cloud.cfg.d/99_zeromon.cfg
```

This `cloud-config` script will do the following upon the first boot of a newly deployed EC2 instance:
- Install Ansible
- Clone this Git repository
- Configure Ansible for local execution
- Execute our Ansible playbook and role ([`setup.yaml`](setup.yaml)) to completely set up a working Zabbix installation
- Place instructions in the `root` user prompt on how to log in to the Zabbix web user interface

And finally, just before clearing bash history and building our AMI, we remove the existing SSH host keys as well as our authorized SSH keys from the `root` and `ubuntu` user accounts.
They will be replaced with your own keys by AWS upon your first launch of your own instance.

```
sudo rm /etc/ssh/ssh_host_* /root/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
history -c
```
