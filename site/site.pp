$timezone_timezone = 'Europe/Zurich'
$timezone_hw_utc = true
$puppi = true
$monitor = true
$monitor_tool = ['puppi']
$firewall = true
$firewall_tool = 'iptables'
$ntp_server = ['fw.home.ledcom.ch', '0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org',]
$chrome_package = 'chromium'
$chrome_share_dir = '/usr/share/chromium-browser/'
$dashing_dashboard_git_url = 'https://github.com/gehel/dashing-dashboard.git'


Exec {
  path => '/usr/sbin:/usr/bin:/sbin:/bin', }

node default {
  include apt
  include dashing
  include locales
  include ntp
  include openssh
  include puppi
  include rclocal
  include sudo
  include timezone

  class { 'r10k':
    remote  => 'https://github.com/gehel/raspbian-kiosk.git',
    version => '1.2.0',
  } -> cron { 'r10k-deploy-env':
    command => '/usr/local/bin/r10k deploy environment -p',
    minute  => '0',
  }

  package { 'puppet': } -> cron { 'puppet-apply':
    command => '/usr/bin/puppet apply --modulepath=/etc/puppet/environments/production/modules:/etc/puppet/environments/production/dist /etc/puppet/environments/production/site/site.pp',
    hour    => '*',
    minute  => '10',
  }

  class { 'keyboard':
    layout  => 'ch',
    variant => 'fr',
  }

  class { 'role::kiosk':
    display_rotate     => '3',
    framebuffer_width  => 1920,
    framebuffer_height => 1080,
  }
}
