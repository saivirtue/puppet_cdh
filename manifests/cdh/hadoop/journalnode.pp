# == Class cdh::hadoop::journalnode
#
class puppet_cdh::cdh::hadoop::journalnode inherits puppet_cdh::cdh::hadoop::namenode::standby {
    Class['puppet_cdh::cdh::hadoop::init'] -> Class['puppet_cdh::cdh::hadoop::journalnode']

    # install jobtracker daemon package
    package { 'hadoop-hdfs-journalnode':
        ensure => 'installed'
    }

    # Ensure that the journanode edits directory has the correct permissions.
    file { $dfs_journalnode_edits_dir:
        ensure  => 'directory',
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => Package['hadoop-hdfs-journalnode'],
    }

    # install datanode daemon package
    service { 'hadoop-hdfs-journalnode':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'journalnode',
        require    => File[$dfs_journalnode_edits_dir],
    }
}
