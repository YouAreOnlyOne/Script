
1、修改 CONFIG_COMPUTE_HOSTS、CONFIG_STORAGE_HOST为计算节点IP，逗号分割，例如 192.168.11.11,192.168.11.12

2、修改其余IP为控制节点IP，例如 CONFIG_CONTROLLER_HOST=192.168.11.10

3、每个节点分别修改hostname以及hosts，
```
hostnamectl set-hostname --static server-xx

cat << EOF >> /etc/hosts
172.20.xx.31 server-31
172.20.xx.32 server-32
172.20.xx.33 server-33
172.20.xx.31 dev.registry.io
EOF

```

4、节点部署方案：

    主要节点名称：CONFIG_CONTROLLER_HOST、CONFIG_NETWORK_HOSTS、（CONFIG_COMPUTE_HOSTS、CONFIG_STORAGE_HOST）
    1）控制节点：1，计算节点：2；
    2）控制节点：1，网络节点：1，计算节点：2；
    3）控制节点：30，网络节点：30，计算节点100，存储节点：100+；
    
5、配置网络

创建br-ex网桥配置，创建并编辑/etc/sysconfig/network-scripts/ifcfg-br-ex
```

DEVICE=br-ex

ONBOOT=yes

DEVICETYPE=ovs

TYPE=OVSBridge

BOOTPROTO=static

IPADDR=192.168.211.60

NETMASK=255.255.255.0

GATEWAY=192.168.211.1
```
将ens33网卡桥接到br-ex上去，修改/etc/sysconfig/network-scripts/ifcfg-ens33
```
DEVICE=ens33

ONBOOT=yes

DEVICETYPE=ovs

TYPE=OVSPort

BOOTPROTO=yes

OVS_BRIDGE=br-ex

```
桥接完成后查看网卡信息，会发现ens33已经没有了ip地址，ip转移到了br-ex网桥上。

6、同步时间
    1）控制节点
    
    ```
    yum -y install ntpdate 
    ntpdate ntp.aliyun.com
    yum -y install ntp
    vim /etc/ntpd.conf
    
    restrict default nomodify
    restrict 192.168.100.0
    注释掉
    #server 0.centos.pool.ntp.org iburst
    #server 1.centos.pool.ntp.org iburst
    #server 2.centos.pool.ntp.org iburst
    #server 3.centos.pool.ntp.org iburst
    
    添加
    server 127.127.1.0
    fudge 127.127.1.0 stratum 10
    
    systemctl disable chronyd.service
    systemctl restart ntpd
    systemctl enable ntpd
    
    ```
    2)计算节点
    ```
    yum -y install ntpdate 
    ntpdate ct
    crontab -e 
    ```

7、配置端口访问

需要配置的端口，如：5000，8778,2379，3306，等等。
```
iptables -I INPUT -p tcp --dport 5000 -j ACCEPT #开启5000端口  
iptables -A INPUT -p tcp -m tcp --dport 5000 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 5000 -j ACCEPT

service iptables save #保存配置  
service iptables restart #重启服务
iptables -L -n
cat /etc/sysconfig/iptables
```
