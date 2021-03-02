#!/bin/bash

yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine -y
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
systemctl start docker
systemctl enable docker

cp /home/zun/compute/admin-openrc.sh ~/
source ~/admin-openrc.sh
groupadd --system kuryr
useradd --home-dir "/var/lib/kuryr" --create-home --system --shell /bin/false -g kuryr kuryr
mkdir -p /etc/kuryr
chown kuryr:kuryr /etc/kuryr
yum -y install python3-pip git python3-devel libffi-devel gcc openssl-devel numactl
mkdir ~/.pip
cp /home/zun/compute/pip.conf ~/.pip/
pip3 install --upgrade pip
python3 -m pip install --upgrade setuptools
pip3 install mysql-connector-python
#pip3 install mysqlclient
pip3 install SQLAlchemy
pip3 install PyMySQL
pip3 install python-zunclient
cd /var/lib/kuryr
git clone -b stable/train https://github.com/openstack/kuryr-libnetwork.git
chown -R kuryr:kuryr kuryr-libnetwork
cd kuryr-libnetwork
pip3 install -r requirements.txt
python3 setup.py install
su -s /bin/sh -c "./tools/generate_config_file_samples.sh" kuryr
#su -s /bin/sh -c "cp etc/kuryr.conf.sample /etc/kuryr/kuryr.conf" kuryr
cp /home/zun/compute/kuryr.conf /etc/kuryr/
cp /home/zun/compute/kuryr-libnetwork.service /etc/systemd/system/
systemctl enable kuryr-libnetwork
systemctl start kuryr-libnetwork
systemctl status kuryr-libnetwork
systemctl restart docker

groupadd --system zun
useradd --home-dir "/var/lib/zun" --create-home --system  --shell /bin/false  -g zun zun
mkdir -p /etc/zun
chown zun:zun /etc/zun
cd /var/lib/zun
git clone -b stable/train https://github.com/openstack/zun.git
chown -R zun:zun zun
cd zun
pip3 install -r requirements.txt
python3 setup.py install

su -s /bin/sh -c "oslo-config-generator --config-file etc/zun/zun-config-generator.conf" zun
#su -s /bin/sh -c "cp etc/zun/zun.conf.sample /etc/zun/zun.conf" zun
su -s /bin/sh -c "cp etc/zun/rootwrap.conf /etc/zun/rootwrap.conf" zun
su -s /bin/sh -c "mkdir -p /etc/zun/rootwrap.d" zun
su -s /bin/sh -c "cp etc/zun/rootwrap.d/* /etc/zun/rootwrap.d/" zun
echo "zun ALL=(root) NOPASSWD: /usr/local/bin/zun-rootwrap /etc/zun/rootwrap.conf *" | sudo tee /etc/sudoers.d/zun-rootwrap
cp /home/zun/compute/compute.conf /etc/zun/zun.conf
chown zun:zun /etc/zun/zun.conf

mkdir -p /etc/systemd/system/docker.service.d
cp /home/zun/compute/docker.conf /etc/systemd/system/docker.service.d/
systemctl daemon-reload
systemctl restart docker
systemctl status docker

cp /home/zun/compute/zun-compute.service /etc/systemd/system/
systemctl start zun-compute
systemctl enable zun-compute
systemctl status zun-compute

