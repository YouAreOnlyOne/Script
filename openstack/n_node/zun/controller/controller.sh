#!/bin/bash


mysql -uroot -pe1b49878fc6c4ef4
CREATE DATABASE zun;
grant all privileges on zun.* to 'zun'@'localhost' identified by 'zun';
grant all privileges on zun.* to 'zun'@'%' identified by 'zun';
quit

cp /home/zun/controller/admin-openrc.sh ~/
source ~/admin-openrc.sh
openstack user create --domain default --password-prompt zun
openstack role add --project services --user zun admin
openstack user create --domain default --password-prompt kuryr
openstack role add --project services --user kuryr admin
openstack service create --name zun --description "Container Service" container
openstack endpoint create --region RegionOne container public http://10.95.85.101:9517/v1
openstack endpoint create --region RegionOne container internal http://10.95.85.101:9517/v1
openstack endpoint create --region RegionOne container admin http://10.95.85.101:9517/v1

groupadd --system zun
useradd --home-dir "/var/lib/zun" --create-home --system  --shell /bin/false  -g zun zun
mkdir -p /etc/zun
chown zun:zun /etc/zun
yum -y install python3-pip git python3-devel libffi-devel gcc openssl-devel
mkdir ~/.pip
cp /home/zun/controller/pip.conf ~/.pip/
pip3 install --upgrade pip
python3 -m pip install --upgrade setuptools
pip3 install mysql-connector-python
#pip3 install mysqlclient
pip3 install SQLAlchemy
pip3 install PyMySQL
pip3 install python-memcached
pip3 install python-zunclient
cd /var/lib/zun
git clone -b stable/train https://github.com/openstack/zun.git
chown -R zun:zun zun
cd zun
pip3 install -r requirements.txt
python3 setup.py install
su -s /bin/sh -c "oslo-config-generator --config-file etc/zun/zun-config-generator.conf" zun
#su -s /bin/sh -c "cp etc/zun/zun.conf.sample /etc/zun/zun.conf" zun
su -s /bin/sh -c "cp etc/zun/api-paste.ini /etc/zun" zun
cp /home/zun/controller/controller.conf /etc/zun/zun.conf
chown zun:zun /etc/zun/zun.conf
su -s /bin/sh -c "zun-db-manage upgrade" zun
cp /home/zun/controller/zun-api.service /etc/systemd/system/
cp /home/zun/controller/zun-wsproxy.service /etc/systemd/system/
systemctl start zun-api zun-wsproxy
systemctl enable zun-api zun-wsproxy
systemctl status zun-api zun-wsproxy

yum install etcd -y
cp /home/zun/controller/etcd.conf /etc/etcd/
systemctl enable etcd
systemctl start etcd
systemctl status etcd
etcdctl cluster-health

#cd /var/lib/zun
#git clone -b stable/train https://github.com/openstack/zun-ui.git
#cd zun-ui
#pip3 install .
#cp zun_ui/enabled/* /usr/share/openstack-dashboard/openstack_dashboard/local/enabled/
#python3 /usr/share/openstack-dashboard/manage.py collectstatic
#python3 /usr/share/openstack-dashboard/manage.py compress
#systemctl restart httpd memcached
#systemctl statussy httpd memcached

openstack appcontainer service list
openstack appcontainer list
zun list