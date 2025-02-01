#!/bin/bash
## Create user alloydbomni. This user will be used on all VM's to run the alloydb software.
sudo useradd -s /bin/bash -u 1500 -m -G adm,video alloydbomni
sudo usermod -a -G wheel alloydbomni
sudo usermod -a -G google-sudoers alloydbomni
