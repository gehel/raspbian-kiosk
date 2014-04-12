$timezone = 'Europe/Zurich'
$timezone_hw_utc = true
$puppi = true
$monitor = true
$monitor_tool = ['puppi']
$firewall = true
$firewall_tool = 'ptables'

node default {
  include apt
  include openssh
  include puppi
  include rclocal
  include sudo
  include timezone

  class { 'r10k':
    remote      => 'https://github.com/gehel/raspbian-kiosk.git',
    mcollective => false,
  } -> cron { 'r10k-deploy-env':
    command => '/usr/local/bin/r10k deploy environment -p',
    minute  => '*/5',
  }

  package { 'puppet': } -> cron { 'puppet-apply':
    command => '/usr/bin/puppet apply --modulepath=/etc/puppet/environments/production/modules:/etc/puppet/environments/production/dist /etc/puppet/environments/production/site/site.pp',
    hour    => '*',
  }

  class { 'locales':
    default   => 'en_US.UTF-8',
    available => ["en_US.UTF-8 UTF-8"],
  }

  class { 'role::kiosk':
  }
}
