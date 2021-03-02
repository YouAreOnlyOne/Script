#!/bin/bash

yum update -y
yum -y install gcc gcc-c++ perl kernel-devel kernel-headers
yum -y install git python3 uwsgi
mkdir -p /opt/stack/logs/

# 方式一：
#git clone 内网仓库地址 /home/auge/
#cp /home/auge/script/zun/devstack.tar.gz /opt/stack/
#cp /home/auge/script/zun/kuryr-libnetwork.tar.gz /opt/stack/
#cp /home/auge/script/zun/zun.tar.gz /opt/stack/
#cp /home/auge/script/zun/requirements.tar.gz /opt/stack/
#
#cd /opt/stack/
#tar -zxvf devstack.tar.gz
#cd devstack
#git init
#cd ..
#tar -zxvf kuryr-libnetwork.tar.gz
#cd kuryr-libnetwork
#git init
#cd ..
#tar -zxvf zun.tar.gz
#cd zun
#git init
#cd ..
#tar -zxvf requirements.tar.gz
#cd requirements
#git init
#cd ..

# 方式二：
git clone -b stable/train https://github.com/openstack/devstack.git /opt/stack/devstack
git clone -b stable/train https://github.com/openstack/kuryr-libnetwork.git /opt/stack/kuryr-libnetwork
git clone -b stable/train https://github.com/openstack/zun.git /opt/stack/zun
git clone -b stable/train https://github.com/openstack/requirements.git /opt/stack/requirements

HOST_IP=172.16.23.140

cat /opt/stack/zun/devstack/local.conf.sample |
  sed "s/HOST_IP=.*/HOST_IP=$HOST_IP/" \
    >/opt/stack/devstack/local.conf

yum install redhat-lsb -y
cd /opt/stack/devstack/tools/
./create-stack-user.sh

sudo chown -R stack:stack /opt/stack/
su stack
cd /opt/stack/devstack/
./stack.sh

source /opt/stack/devstack/openrc admin admin
