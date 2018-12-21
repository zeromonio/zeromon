# Zeromon

[Zeromon](https://zeromon.io/) provides a pre-built Zabbix installation via an Amazon Machine Image (AMI) on Amazon Web Services (AWS).
The AMI (`ami-00a28cc59e938e179`) is built using this repository.

#### Usage

After deployment of the AMI, you can simply visit the IP address or DNS name of your new EC2 instance.
You will be able to log in to the Zabbix web interface with the default user name of `Admin`.
The password for the Zabbix `Admin` web user can be found by connecting to your EC2 instance via SSH and reading the contents of the file `/root/zabbix_admin_password`.

#### Pricing

The cost for usage of this AMI is $0.05 USD per hour (or basically, $36.00 USD per month) for all instance types in all regions.
We also offer a 7-day 100% money-back guarantee.
Unfortunately, the AMI is not currently within the Amazon GovCloud though.

#### Support

Any questions or concerns can be sent to support@zeromon.io

#### Technical Details

Per the [Ansible](https://www.ansible.com/) automation within this repository, the following software is installed upon the first boot of the AMI:

- [Ubuntu 18.04 LTS](https://www.ubuntu.com/)
- [Zabbix 4.x](https://www.zabbix.com/)
- [Apache 2.4](https://httpd.apache.org/)
- [PHP 7.2](https://secure.php.net/)
- [MariaDB](https://mariadb.org/)
