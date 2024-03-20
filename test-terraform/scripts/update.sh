#!/bin/bash
set -x

sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get update


sudo apt-get -y -qq install --no-install-recommends \
  curl \
  wget \
  git \
  vim \
  apt-transport-https \
  ca-certificates \
  lsb-release \
  software-properties-common \
  apt-utils \
  putils-ping \
  libicu-dev \
  gnupg \
  net-tools \
  openssl \
  nload \
  python3-pip


sudo groupadd -r qadmin
sudo useradd -m -s /bin/bash qadmin
sudo usermod -a -G qadmin qadmin
sudo usermod -a -G sudo qadmin
sudo cp /etc/sudoers /etc/sudoers.orig

echo "qadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/qadmin

# Installing SSH key
#sudo mkdir -p /home/qadmin/.ssh
#sudo chmod 700 /home/qadmin/.ssh
#sudo touch /home/qadmin/.ssh/authorized_keys
#sudo cp /tmp/tf-packer.pub /home/qadmin/.ssh/authorized_keys
#ssh-keygen -t rsa
#sudo chmod 600 /home/qadmin/.ssh/authorized_keys
#sudo chown -R qadmin:qadmin /home/qadmin/.ssh
#sudo usermod --shell /bin/bash qadmin

#sudo -H -i -u qadmin -- env bash << EOF
#whoami
#echo ~qadmin

#cd /home/qadmin
#EOF

#sudo -H -i -u qadmin -- env bash << EOF > /home/qadmin/.ssh/authorized_keys
#ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDq6JL8J5/rKFpAOVGVpXYTjD5etKRHkSFzsNeBqoVlULKDXDBzlocryQGDNL1LLPPwWjpkPT60W4IRt8z7pSx3C7JA0SV6K6zQuNl9qPDG2ToTaj3AqHZb9JQeYNjSkgygpcQVudsvY3BHtrYNpsK2QA5fxGmjjwV8+bfbCe5juE+/Y/RGPOS/3Wz3hahklt3mtaIe+WdjkKQgN3gURLoIGsSGcOZq31ImImH/qB1wDedJMZ1Wz5GDn6FBjQJ+TVSHFQEo44qxxyugh0Lf3dPVMqgq8nA1Clx0nPC07uPnB3dge76Q2ILf2e6ARla2TpI0rhUqObuV5D9sPDpmM0hYuGDXRCveA4lTUea3lYy56akczq7kcmUeDGn+TB7pCoEsOq17z1JG9O9tiS0LpcqEmSpUqsz8rzQLigbRq/BccmsjHx+ViiMmsXiwREFIzLDUrWMEEj0oxSsK4koKdrglIAu4Q0WtLrNlAaq1++fK5oK1OZMQ7e9e7Vi0pfKC1Pc= sigma\q.shahrour@QSHAHROUR2
#EOF
sudo apt-get update -y
sudo apt-get install --yes awscli
if [ $? != 0 ]; then
  sudo snap install -y aws-cli --classic
fi
exit 0 

