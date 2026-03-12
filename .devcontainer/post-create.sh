#!/bin/sh
apt-get update
apt-get install -y btrfs-progs openssh-server openssh-client e2fsprogs
pip install uv
uv sync --locked --extra dev

sed -r "s/[#]{0,1}Port [0-9]{2,5}/Port $SSH_PORT/g" /etc/ssh/sshd_config -i

# create ssh key which let root users to access to localhost
# to test send btrfs sends methods over ssh
ssh-keygen -f /root/.ssh/id_rsa -N ""
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
ssh-keyscan -p $SSH_PORT localhost >> /root/.ssh/known_hosts
mkdir -p /var/lib/buttervolume/received

git config --global --add safe.directory /workspaces/buttervolume
