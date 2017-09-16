# openresty
This module is created to setup openresty in Linux server. I have created this module on rhel-6.

Step1 : Download this module
Step2 : Copy top level directory "openresty" to /etc/puppet/modules
# cp openresty /etc/puppet/modules

Step3 : Enable this module in your puppet main config file.

# vim /etc/puppet/manifests/site.pp

node default {
  include openresty
}

