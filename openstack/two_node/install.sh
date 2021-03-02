#!/bin/bash

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum update -y
yum -y install gcc gcc-c++ perl kernel-devel kernel-headers
yum -y install git python3 uwsgi
mkdir -p /opt/stack/logs/
mkdir /.pip
cp pip.conf /.pip/

git clone -b stable/train https://github.com/openstack/devstack.git /opt/stack/devstack
git clone -b stable/train https://github.com/openstack/kuryr-libnetwork.git /opt/stack/kuryr-libnetwork
git clone -b stable/train https://github.com/openstack/zun.git /opt/stack/zun
git clone -b stable/train https://github.com/openstack/requirements.git /opt/stack/requirements

cp controller.conf /opt/stack/devstack/local.conf
#cp compute.conf /opt/stack/devstack/local.conf
cp stackrc /opt/stack/devstack/

yum install redhat-lsb -y
cd /opt/stack/devstack/tools/
./create-stack-user.sh

sudo chown -R stack:stack /opt/stack/
su stack
cd /opt/stack/devstack/
./stack.sh

source /opt/stack/devstack/openrc admin admin