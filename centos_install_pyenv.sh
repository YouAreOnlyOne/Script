# 1.>安装依赖包:
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel -y
yum install git -y

# 2.>安装pyenv包:
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# 3.>设置环境变量:
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile

# 4.>刷新环境变量：
exec "$SHELL"
source ~/.bash_profile

pyenv version

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