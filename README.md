sudo apt install -y openssh-server

# 1. 编辑配置
sudo nano /etc/ssh/sshd_config
# 修改 Port 2222

# 2. 测试语法
sudo sshd -t

# 3. 修改ssh.socket, socket 激活（关键！）ubuntu22以后开始使用ssh.socket,造成sshd_config不起作用
/usr/lib/systemd/system/ssh.socket
# 修改 Port 2222

sudo systemctl restart ssh.service
sudo systemctl restart ssh.socket

# 4. 检查监听
ss -tuln | grep ':2222'

ubuntu24的这个大坑
