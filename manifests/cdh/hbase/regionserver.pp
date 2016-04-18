class puppet_cdh::cdh::hbase::regionserver inherits puppet_cdh::cdh::hbase::init {
  if $enabled {
    #    Package['hbase-regionserver'] -> Service['hbase-regionserver']
  } else {
    #    Service['hbase-regionserver'] -> Package['hbase-regionserver']
  }
  if ($::hostname in $regionserver_hosts) {
    package { 'hbase-regionserver': ensure => $ensure, }
  }

  # service start/stop is handled by shell
  #  service { 'hbase-regionserver':
  #    ensure     => $enabled,
  #    enable     => $enabled,
  #    hasstatus  => true,
  #    hasrestart => true,
  #  }
}
