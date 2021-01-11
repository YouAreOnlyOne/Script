
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo  # 指定阿里云镜像源
yum clean all  yum makecache fast  # 重新生成缓存
yum -y install docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker
docker version

echo ""
echo ""
echo ""
echo "============================================================"
echo ""
echo "Installation Complete !"
echo ""
echo "官网：http://52014991.xyz"
echo "博客：https://blog.csdn.net/u014374009"
echo "代码：https://github.com/YouAreOnlyOne"
echo ""
echo "============================================================"
echo ""
echo ""