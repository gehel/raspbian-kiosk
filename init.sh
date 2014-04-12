#!/bin/bash

cat > /etc/r10k.yaml << EOF
:cachedir: '/var/cache/r10k'
:sources:
  :plops:
    remote: 'https://github.com/gehel/raspbian-kiosk.git'
    basedir: '/etc/puppet/environments'
:purgedirs:
  - '/etc/puppet/environments'
EOF

wget http://apt.puppetlabs.com/puppetlabs-release-`lsb_release -cs`.deb
dpkg -i puppetlabs-release-`lsb_release -cs`.deb
apt-get update
apt-get dist-upgrade -y

echo 'install puppet and dependencies'
/usr/sbin/locale-gen enUS.utf8
export LANGUAGE=en_US.utf8
export LC_ALL=en_US.utf8
export LANG=en_US.utf8

apt-get install -y unattended-upgrades puppetmaster git rubygems ruby-systemu ruby-log4r libsystemu-ruby liblog4r-ruby
gem install --no-ri --nordoc r10k

/usr/local/bin/r10k -v info deploy environment

echo 'puppet run to ensure basic configuration'
puppet apply \
  --modulepath=/etc/puppet/environments/production/modules:/etc/puppet/environments/production/dist \
  /etc/puppet/environments/production/site/site.pp

