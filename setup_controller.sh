#!/bin/bash
## Create ssh keys that will be used for connectivity with the VM's
ssh-keygen -b 2048 -t rsa -f omni_ssh -q -N ""


## Install required packages
sudo dnf install -y ansible-core python3.12-psycopg2 wget


## Download and install ansible collection

COLLECTION_PATH=https://storage.googleapis.com/alloydb-omni-custom-releases/vm-automation/0.3.0/ansible-collection
wget $COLLECTION_PATH/ansible-role-docker-7.4.1.tar.gz
wget $COLLECTION_PATH/ansible-posix-1.6.1.tar.gz
wget $COLLECTION_PATH/community-crypto-2.22.2.tar.gz
wget $COLLECTION_PATH/community-docker-3.13.1.tar.gz
wget $COLLECTION_PATH/community-general-9.5.0.tar.gz
wget $COLLECTION_PATH/community-postgresql-3.7.0.tar.gz
wget $COLLECTION_PATH/containers-podman-1.16.1.tar.gz
wget $COLLECTION_PATH/google-alloydbomni-0.3.0.tar.gz
ansible-galaxy role install --force ansible-role-docker-7.4.1.tar.gz
mv ~/.ansible/roles/ansible-role-docker-7.4.1.tar.gz ~/.ansible/roles/geerlingguy.docker
ansible-galaxy collection install --force ansible-posix-1.6.1.tar.gz
ansible-galaxy collection install --force community-crypto-2.22.2.tar.gz
ansible-galaxy collection install --force community-docker-3.13.1.tar.gz
ansible-galaxy collection install --force community-general-9.5.0.tar.gz
ansible-galaxy collection install --force community-postgresql-3.7.0.tar.gz
ansible-galaxy collection install --force containers-podman-1.16.1.tar.gz
ansible-galaxy collection install --force google-alloydbomni-0.3.0.tar.gz

## Setup image repository

wget https://storage.googleapis.com/alloydb-omni-custom-releases/vm-automation/0.3.0/images/google-alloydbomni-15.7.0-bronze.0.tar
wget https://storage.googleapis.com/alloydb-omni-custom-releases/vm-automation/0.3.0/images/google-alloydbomni-monitoring-agent-0.3.0.tar
wget https://storage.googleapis.com/alloydb-omni-custom-releases/vm-automation/0.3.0/images/hashicorp-consul-1.19.2.tar
wget https://storage.googleapis.com/alloydb-omni-custom-releases/vm-automation/0.3.0/images/edoburu-pgbouncer-v1.23.1-p2.tar

## Create private container repository

sudo mkdir -p /var/lib/registry
sudo yum install -y httpd-tools
sudo podman run --privileged -d --name registry -p 5000:5000 -v /var/lib/registry:/var/lib/registry --restart=always registry:2

# Add the lines :
sudo echo "[registries.insecure]" >> /etc/containers/registries.conf
sudo echo "registries = ['localhost:5000']" >> /etc/containers/registries.conf
