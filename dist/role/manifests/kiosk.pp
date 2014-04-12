class role::kiosk ($url = 'http://www.google.com/ncr', $user = 'pi') {
  package { [
    'matchbox',
    'chromium',
    'x11-xserver-utils',
    'ttf-mscorefonts-installer',
    'xwit',
    'sqlite3',
    'libnss3']:
    ensure => 'present',
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
