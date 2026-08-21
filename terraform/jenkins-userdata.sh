#!/bin/bash

set -e

exec > >(tee /var/log/jenkins-userdata.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting Trend Store Jenkins server setup..."

apt-get update -y
apt-get upgrade -y

echo "Installing required packages..."

apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  unzip \
  wget \
  fontconfig \
  openjdk-21-jre

echo "Installing Docker..."

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y

apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker
systemctl start docker

echo "Installing Jenkins..."

mkdir -p /etc/apt/keyrings

wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -y

apt-get install -y jenkins

echo "Adding Jenkins to Docker group..."

usermod -aG docker jenkins

systemctl enable jenkins
systemctl restart jenkins

echo "Installing AWS CLI..."

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o /tmp/awscliv2.zip

unzip -q /tmp/awscliv2.zip -d /tmp

/tmp/aws/install

echo "Installing kubectl..."

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm -f kubectl
rm -f /tmp/awscliv2.zip

echo "Verifying installations..."

java -version
docker --version
aws --version
kubectl version --client
systemctl --no-pager status jenkins || true
systemctl --no-pager status docker || true

echo "=============================================="
echo "Trend Store Jenkins server setup completed"
echo "=============================================="
