#!/bin/bash
set -x

yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# yum-config-manager \
#   --add-repo \
#   https://download.docker.com/linux/centos/docker-ce.repo

yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum -y install docker-ce
systemctl enable docker
systemctl start docker

# Control docker with systemd: http/https proxy
mkdir -p /etc/systemd/system/docker.service.d

touch /etc/systemd/system/docker.service.d/http-proxy.conf
cat <<EOF >  /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://10.0.2.2:1087/"
EOF

# touch /etc/systemd/system/docker.service.d/https-proxy.conf
# cat <<EOF >  /etc/systemd/system/docker.service.d/https-proxy.conf
# [Service]
# Environment="HTTPS_PROXY=http://10.0.2.2:1087/"
# EOF

systemctl daemon-reload
systemctl restart docker
systemctl show --property=Environment docker
