# == Class puppet_cdh::cdh::hadoop::master
# Wrapper class for Hadoop master node services:
# - NameNode
# - ResourceManager and HistoryServer (YARN)
#
# This requires that you run your primary NameNode and
# primary ResourceManager on the same host.  Standby services
# can be spread on any nodes.
#
class puppet_cdh::cdh::hadoop::master inherits puppet_cdh::cdh::hadoop::init {
  
  contain puppet_cdh::cdh::hadoop::namenode
  contain puppet_cdh::cdh::hadoop::namenode::primary

  contain puppet_cdh::cdh::hadoop::resourcemanager
  contain puppet_cdh::cdh::hadoop::historyserver
  
  # Install a check_active_namenode script, this can be run
  # from any Hadoop client, but we will only run it from master nodes.
  # This script is useful for nagios/icinga checks.
  file { '/usr/local/bin/check_hdfs_active_namenode':
    source => 'puppet:///modules/puppet_cdh/hadoop/check_hdfs_active_namenode',
    owner  => 'root',
    group  => 'hdfs',
    mode   => '0555',
  }
}
