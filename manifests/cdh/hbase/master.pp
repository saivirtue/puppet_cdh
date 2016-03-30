class puppet_cdh::cdh5::hbase::master () inherits puppet_cdh::cdh5::hbase {
  Class['puppet_cdh::cdh5::hbase'] -> Class['puppet_cdh::cdh5::hbase::master']

  package { 'hbase-master':
    ensure => 'present',
    tag    => 'cloudera-cdh5',
  }

  service { 'hbase-master':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    alias      => 'hbase-master',
    require    => Package['hbase-master'],
  }
}
