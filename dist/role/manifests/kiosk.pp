class role::kiosk ($url = 'http://www.google.com/ncr', $user = 'kiosk', $group = 'kiosk',) {
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
    content => template('modules/role/kiosk/boot-config.txt.erb'),
  }

  group { $group: ensure => 'present', }

  user { $user:
    ensure => 'present',
    gid    => $group,
    home   => "/home/${user}",
  }

  file { "/home/${user}":
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }

  file { '/boot/xinitrc':
    ensure  => 'present',
    content => template('modules/role/kiosk/xinitrc.erb'),
  }

  rclocal::script { 'tv-screen':
    priority => '99',
    content  => template('modules/role/kiosk/rclocal.erb'),
  }
}