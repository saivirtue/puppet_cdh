class puppet_cdh::cdh::hbase::master inherits puppet_cdh::cdh::hbase::init {
  if $enabled {
    Class['puppet_cdh::cdh::hadoop::namenode'] -> Class['puppet_cdh::cdh::hbase::master']
    #    Package['hbase-master'] -> Service['hbase-master']
  } else {
    #    Service['hbase-master'] -> Package['hbase-master']
  }

  package { 'hbase-master': ensure => $ensure, }

  # sudo -u hdfs hdfs dfs -mkdir /hbase
  # sudo -u hdfs hdfs dfs -chmod 0755 /hbase
  #note : make sure namenode is enabled and start !
  puppet_cdh::cdh::hadoop::directory { '/hbase':
    owner   => 'hbase',
    group   => 'hbase',
    mode    => '0755',
#    require => Service['hadoop-hdfs-namenode'],
  }

  # service start/stop is handled by shell
  #  service { 'hbase-master':
  #    ensure     => $enabled,
  #    enable     => $enabled,
  #    hasstatus  => true,
  #    hasrestart => true,
  #  }
}
