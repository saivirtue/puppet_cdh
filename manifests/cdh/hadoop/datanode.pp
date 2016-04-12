# == Class puppet_cdh::cdh::hadoop::datanode
# Installs and starts up a Hadoop DataNode.
#
class puppet_cdh::cdh::hadoop::datanode inherits puppet_cdh::cdh::hadoop::worker {
    
    if $enabled {
      Package['hadoop-hdfs-datanode'] -> Service['hadoop-hdfs-datanode']
      
      # install jobtracker daemon package
      package { 'hadoop-hdfs-datanode':
        ensure => $ensure
      }
    }

    # install datanode daemon package
    service { 'hadoop-hdfs-datanode':
        ensure     => $enabled,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'datanode',
    }
}