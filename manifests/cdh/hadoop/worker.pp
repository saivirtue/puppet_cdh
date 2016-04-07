# == Class puppet_cdh::cdh::hadoop::worker
# Wrapper class for Hadoop Worker node services:
# - DataNode
# - NodeManager (YARN)
#
# This class will attempt to create and manage the required
# local worker directories defined in the $datanode_mounts array.
# You must make sure that the paths defined in $datanode_mounts are
# formatted and mounted properly yourself; This puppet module does not
# manage them.
#
class puppet_cdh::cdh::hadoop::worker inherits puppet_cdh::cdh::hadoop::init {
    
    if $enabled {
      Puppet_cdh::Cdh::Hadoop::Worker::Paths[$datanode_mounts] -> Class['puppet_cdh::cdh::hadoop::datanode']
    } else {
      Class['puppet_cdh::cdh::hadoop::datanode'] -> Puppet_cdh::Cdh::Hadoop::Worker::Paths[$datanode_mounts]
    }

    puppet_cdh::cdh::hadoop::worker::paths { $datanode_mounts:
      dfs_data_path   => $dfs_data_path,
      ensure         => $enabled,
      yarn_local_path => $yarn_local_path,
      yarn_logs_path  => $yarn_logs_path,
    }

    class { 'puppet_cdh::cdh::hadoop::datanode':
    }

    # YARN uses NodeManager.
    class { 'puppet_cdh::cdh::hadoop::nodemanager':
    }
}
