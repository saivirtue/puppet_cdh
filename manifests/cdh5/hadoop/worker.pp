# == Class puppet-cdh::cdh5::hadoop::worker
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
class puppet-cdh::cdh5::hadoop::worker {
    Class['puppet-cdh::cdh5::hadoop'] -> Class['puppet-cdh::cdh5::hadoop::worker']

    puppet-cdh::cdh5::hadoop::worker::paths { $::puppet-cdh::cdh5::hadoop::datanode_mounts: }

    class { 'puppet-cdh::cdh5::hadoop::datanode':
        require => puppet-cdh::Cdh5::Hadoop::Worker::Paths[$::puppet-cdh::cdh5::hadoop::datanode_mounts],
    }

    # YARN uses NodeManager.
    class { 'puppet-cdh::cdh5::hadoop::nodemanager':
        require => puppet-cdh::Cdh5::Hadoop::Worker::Paths[$::puppet-cdh::cdh5::hadoop::datanode_mounts],
    }
}
