#cloud-config

#packages
package_update: true
package_upgrade: true
packages:
 - unattended-upgrades

# Automatic security upgrades
write_files:
- path: etc/apt/apt.conf.d/10periodic
  content: |
    APT::Periodic::Update-Package-Lists "1";
    APT::Periodic::Download-Upgradeable-Packages "1";
    APT::Periodic::AutocleanInterval "7";
    APT::Periodic::Unattended-Upgrade "1";

output:
  all: '| tee -a /var/log/cloud-init-output.log'

runcmd:
 # -e: Exit as soon as any line fails
 # -x: Print each command that is going to be executed
 - set -ex
 - echo ${ssh_port}
 - curl -fsSL https://get.docker.com -o get-docker.sh
 - sh get-docker.sh
 - usermod -aG docker ${docker_user}