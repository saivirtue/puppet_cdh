# == Class puppet_cdh::cdh::hadoop::namenode::secondarynamenode
# Hadoop Secondary NameNode.
#
class puppet_cdh::cdh::hadoop::namenode::secondarynamenode inherits puppet_cdh::cdh::hadoop::init {
  # install secondary namenode daemon package
  package { 'hadoop-hdfs-secondarynamenode':
    ensure => $ensure,
  }
}
