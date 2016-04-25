# == Class puppet_cdh::cdh::hadoop::datanode
# Installs and starts up a Hadoop DataNode.
#
class puppet_cdh::cdh::hadoop::datanode inherits puppet_cdh::cdh::hadoop::init {
    
    puppet_cdh::cdh::hadoop::worker::paths { $datanode_mounts:
      dfs_data_path   => $dfs_data_path,
      ensure          => $enabled,
      yarn_local_path => $yarn_local_path,
      yarn_logs_path  => $yarn_logs_path,
    }
    
    if $enabled {
      Package['hadoop-hdfs-datanode'] -> Service['hadoop-hdfs-datanode']
    } else {
      Service['hadoop-hdfs-datanode'] -> Package['hadoop-hdfs-datanode']
    }
    # install jobtracker daemon package
    package { 'hadoop-hdfs-datanode':
      ensure => $ensure
    }

    # install datanode daemon package
    service { 'hadoop-hdfs-datanode':
      ensure     => $enabled,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
    }
}