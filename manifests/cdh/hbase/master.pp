class puppet_cdh::cdh::hbase::master inherits puppet_cdh::cdh::hbase::init {

  if $enabled {
    Package['hbase-master'] -> Service['hbase-master']
    
  } else {
    Service['hbase-master'] -> Package['hbase-master']
  }

  package { 'hbase-master':
    ensure => $ensure,
  }

  service { 'hbase-master':
    ensure     => $enabled,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }
}
