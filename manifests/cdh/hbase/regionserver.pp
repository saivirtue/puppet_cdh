class puppet_cdh::cdh5::hbase::regionserver (
  ) inherits puppet_cdh::cdh5::hbase {

  Class['puppet_cdh::cdh5::hbase::master'] -> Class['puppet_cdh::cdh5::hbase::regionserver']
  package { 'hbase-regionserver':
    ensure => 'present',
    tag    => 'cloudera-cdh5',
  }
  
  service { 'hbase-regionserver':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    alias      => 'hbase-regionserver',
    require    => Package['hbase-regionserver'],
  }
}
