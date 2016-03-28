class puppet_cdh::cdh5::hbase::regionserver (
  $cluster_name,
  $hostname,
  ) inherits puppet_cdh::cdh5::hbase {

  Class['puppet_cdh::cdh5::hbase'] -> Class['puppet_cdh::cdh5::hbase::master']
  package { 'hbase-regionserver':
    ensure => 'present',
    tag    => 'cloudera-cdh5',
  }
}
