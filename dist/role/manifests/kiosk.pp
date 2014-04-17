class role::kiosk (
  $url                = 'http://www.google.com/ncr',
  $user               = 'pi',
  $framebuffer_width  = 1920,
  $framebuffer_height = 1080,
  $display_rotate     = '0') {
  if !is_integer($framebuffer_width) {
    fail("framebuffer_width is not an integer [${framebuffer_width}]")
  }

  if !is_integer($framebuffer_height) {
    fail("framebuffer_height is not an integer [${framebuffer_height}]")
  }

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
  }

  file { '/boot/xinitrc':
    ensure  => 'present',
    content => template('role/kiosk/xinitrc.erb'),
  }

  rclocal::script { 'tv-screen':
    priority => '99',
    content  => template('role/kiosk/rclocal.erb'),
    autoexec => false,
  }
}
