class role::kiosk (
  $urls               = ['http://www.wikipedia.org', 'http://en.wikipedia.org/wiki/HTML_element#Frames',],
  $refresh_interval   = 5000,
  $user               = 'pi',
  $user_home          = '/home/pi',
  $framebuffer_width  = 1920,
  $framebuffer_height = 1080,
  $display_rotate     = '0') {
  if !is_integer($refresh_interval) {
    fail("refresh_interval is not an integer [${refresh_interval}]")
  }

  if !is_integer($framebuffer_width) {
    fail("framebuffer_width is not an integer [${framebuffer_width}]")
  }

  if !is_integer($framebuffer_height) {
    fail("framebuffer_height is not an integer [${framebuffer_height}]")
  }

  $dashboard_file = "${user_home}/dashboard.html"

  package { ['chromium', 'libnss3', 'matchbox', 'sqlite3', 'ttf-mscorefonts-installer', 'x11-xserver-utils', 'xwit',]:
    ensure => 'present',
    before => Rclocal::Script['tv-screen'],
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/boot/config.txt':
    ensure  => 'present',
    content => template('role/kiosk/boot-config.txt.erb'),
    notify  => Exec['reboot'],
  }

  file { '/boot/xinitrc':
    ensure  => 'present',
    content => template('role/kiosk/xinitrc.erb'),
    notify  => Exec['reboot'],
  }

  file { $dashboard_file:
    ensure  => 'present',
    owner   => $user,
    content => template('role/kiosk/dashboard.html.erb'),
    notify  => Exec['reboot'],
  }

  rclocal::script { 'tv-screen':
    priority => '99',
    content  => template('role/kiosk/rclocal.erb'),
    autoexec => false,
    notify   => Exec['reboot'],
  }

  exec { 'reboot':
    command     => '/sbin/reboot',
    refreshonly => true,
  }

}
