#!/bin/bash

## can be executed with:
## curl https://raw.githubusercontent.com/gehel/raspbian-kiosk/master/init.sh | bash

HOSTNAME=kiosk.home.ledcom.ch

echo 'set hostname'
echo $HOSTNAME > /etc/hostname
hostname --file /etc/hostname

echo 'start by running apt-get update'
apt-get update

echo 'make sure the date/time is more or less correct so that SSL certificate validation works'
date -s "18 APR 2014 12:00:00"

echo 'make sure all packages are up to date'
apt-get dist-upgrade -y

#echo 'generate locales (should not be necessary)'
#/usr/sbin/locale-gen en_US.utf8
#export LANGUAGE=en_US.utf8
#export LC_ALL=en_US.utf8
#export LANG=en_US.utf8

echo 'install puppet and dependencies'
apt-get install -y unattended-upgrades puppet git rubygems ruby-systemu ruby-log4r libsystemu-ruby liblog4r-ruby
gem install --no-ri --no-rdoc r10k

echo 'create r10k configuration'
cat > /etc/r10k.yaml << EOF
:cachedir: '/var/cache/r10k'
:sources:
  :plops:
    remote: 'https://github.com/gehel/raspbian-kiosk.git'
    basedir: '/etc/puppet/environments'
:purgedirs:
  - '/etc/puppet/environments'
EOF

echo 'run r10k to get all configuration'
/usr/local/bin/r10k -v info deploy environment -p

echo 'puppet run to install / configure host'
puppet apply \
  --modulepath=/etc/puppet/environments/production/modules:/etc/puppet/environments/production/dist \
  /etc/puppet/environments/production/site/site.pp

