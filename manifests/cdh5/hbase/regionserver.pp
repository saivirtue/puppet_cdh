class puppet-cdh::cdh5::hbase::regionserver (
  $cluster_name,
  $hostname,
  ) {

  Class['puppet-cdh::cdh5::hbase'] -> Class['puppet-cdh::cdh5::hbase::master']
  package { 'hbase-regionserver':
    ensure => 'present',
    tag    => 'cloudera-cdh5',
  }
}
