# == Class puppet_cdh::cdh5::hadoop::datanode
# Installs and starts up a Hadoop DataNode.
#
class puppet_cdh::cdh5::hadoop::datanode {
    Class['puppet_cdh::cdh5::hadoop'] -> Class['puppet_cdh::cdh5::hadoop::datanode']

    # install jobtracker daemon package
    package { 'hadoop-hdfs-datanode':
        ensure => 'installed'
    }

    # install datanode daemon package
    service { 'hadoop-hdfs-datanode':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'datanode',
        require    => Package['hadoop-hdfs-datanode'],
    }
}