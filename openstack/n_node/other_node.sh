#!/bin/bash

function disable_selinux {
    setenforce 0
    sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config
}

function stop_firewalld {
    systemctl disable firewalld.service
    systemctl stop firewalld.service
}

function install_packstack {
    yum -y install epel-release
    sed -i "s/mirrors.fedoraproject.org/mirrors.aliyun.com/" /etc/yum.repos.d/epel.repo

    yum -y install screen
    yum -y install centos-release-openstack-train
    yum -y install openstack-packstack python-pip ntp

    # 高版本会有 leatherman_curl.so.1.3.0 找不到问题
    rpm -e leatherman --nodeps
    yum -y install leatherman-1.3.0-9.el7.x86_64
}


disable_selinux
stop_firewalld
install_packstack
