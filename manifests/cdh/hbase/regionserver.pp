class puppet_cdh::cdh::hbase::regionserver inherits puppet_cdh::cdh::hbase::init {

  if $enabled {
    Package['hbase-regionserver'] -> Service['hbase-regionserver']
    
  } else {
    Service['hbase-regionserver'] -> Package['hbase-regionserver']
  }

  package { 'hbase-regionserver':
    ensure => $ensure,
  }
  
  service { 'hbase-regionserver':
    ensure     => $enabled,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }
}
