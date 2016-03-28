class puppet_cdh::cdh5::zookeeper {
  package { 'zookeeper':
    ensure => 'present',
    tag    => 'cdh',
  }
  package { 'zookeeper-server':
    ensure => 'present',
    tag    => 'cdh',
  }
  exec { 'zookeeper_server_init':
    command => '/sbin/service zookeeper-server init --myid 1',
    path    => '/usr/bin:/sbin',
    require => [ Package['zookeeper'], Package['zookeeper-server'], ],
    onlyif  => 'test `find /var/lib/zookeeper -maxdepth 0 -empty`',
  }
  service { 'zookeeper-server':
    ensure  => 'running',
    enable  => true,
    require => Exec['zookeeper_server_init'],
  }
}
