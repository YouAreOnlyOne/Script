
# 前期准备
1、准备几台服务器，分别为每台服务器设置hostname,并配置host解析。
```
hostnamectl set-hostname --static server-xx

cat << EOF >> /etc/hosts
172.20.xx.31 server-31
172.20.xx.32 server-32
172.20.xx.33 server-33
172.20.xx.31 dev.registry.io
EOF

```