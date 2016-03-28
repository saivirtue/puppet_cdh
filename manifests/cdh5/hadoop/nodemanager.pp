# == Class puppet_cdh::cdh5::hadoop::nodemanager
# Installs and configures a Hadoop NodeManager worker node.
#
class puppet_cdh::cdh5::hadoop::nodemanager {
    Class['puppet_cdh::cdh5::hadoop'] -> Class['puppet_cdh::cdh5::hadoop::nodemanager']


    package { ['hadoop-yarn-nodemanager', 'hadoop-mapreduce']:
        ensure => 'installed',
    }

    # NodeManager (YARN TaskTracker)
    service { 'hadoop-yarn-nodemanager':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'nodemanager',
        require    => [Package['hadoop-yarn-nodemanager', 'hadoop-mapreduce']],
    }
}

