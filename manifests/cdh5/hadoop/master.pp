# == Class puppet-cdh::cdh5::hadoop::master
# Wrapper class for Hadoop master node services:
# - NameNode
# - ResourceManager and HistoryServer (YARN)
#
# This requires that you run your primary NameNode and
# primary ResourceManager on the same host.  Standby services
# can be spread on any nodes.
#
class puppet-cdh::cdh5::hadoop::master {
  Class['puppet-cdh::cdh5::hadoop'] -> Class['puppet-cdh::cdh5::hadoop::master']

  include puppet-cdh::cdh5::hadoop::namenode::primary

  include puppet-cdh::cdh5::hadoop::resourcemanager
  include puppet-cdh::cdh5::hadoop::historyserver

  # Install a check_active_namenode script, this can be run
  # from any Hadoop client, but we will only run it from master nodes.
  # This script is useful for nagios/icinga checks.
  file { '/usr/local/bin/check_hdfs_active_namenode':
    source => 'puppet:///modules/puppet-cdh/hadoop/check_hdfs_active_namenode',
    owner  => 'root',
    group  => 'hdfs',
    mode   => '0555',
  }
}
