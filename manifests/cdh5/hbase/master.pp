class puppet_cdh::cdh5::hbase::master (
  $cluster_name,
  $hostname,
  ) inherits puppet_cdh::cdh5::hbase {
    
  Class['puppet_cdh::cdh5::hbase'] -> Class['puppet_cdh::cdh5::hbase::master']
  package { 'hbase-master':
    ensure => 'present',
    tag    => 'cloudera-cdh5',
  }
}
