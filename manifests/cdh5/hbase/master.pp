class puppet-cdh::cdh5::hbase::master (
  $cluster_name,
  $hostname,
  ) {
    
  Class['puppet-cdh::cdh5::hbase'] -> Class['puppet-cdh::cdh5::hbase::master']
  package { 'hbase-master':
    ensure => 'present',
    tag    => 'cloudera-cdh5',
  }
}
