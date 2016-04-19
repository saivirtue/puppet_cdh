class puppet_cdh::cdh::hbase::master inherits puppet_cdh::cdh::hbase::init {
  if $enabled {
  } else {
  }

  package { 'hbase-master': ensure => $ensure, }

  # service start/stop is handled by shell
  #  service { 'hbase-master':
  #    ensure     => $enabled,
  #    enable     => $enabled,
  #    hasstatus  => true,
  #    hasrestart => true,
  #  }
}
