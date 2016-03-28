# == Class puppet-cdh::cdh5::hadoop::resourcemanager
# Installs and configures Hadoop YARN ResourceManager.
# This will create YARN HDFS directories.
#
class puppet-cdh::cdh5::hadoop::resourcemanager {
    Class['puppet-cdh::cdh5::hadoop'] -> Class['puppet-cdh::cdh5::hadoop::resourcemanager']

    # In an HA YARN ResourceManager setup, this class will be included on multiple nodes.
    # In order to have this directory check performed by only one resourcemanager,
    # we only use it on the first node in the $resourcemanager_hosts array.
    # This means that the Hadoop Master NameNode must be the same node as the
    # Hadoop Master ResouceManager.
    if !$::puppet-cdh::cdh5::hadoop::yarn_ha_enabled or $::fqdn == $::puppet-cdh::cdh5::hadoop::primary_resourcemanager_host {
        # Create YARN HDFS directories.
        # See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH5-Installation-Guide/cdh5ig_yarn_cluster_deploy.html?scroll=topic_11_4_10_unique_1
        puppet-cdh::cdh5::hadoop::directory { '/var/log/hadoop-yarn':
            # sudo -u hdfs hdfs dfs -mkdir /var/log/hadoop-yarn
            # sudo -u hdfs hdfs dfs -chown yarn:mapred /var/log/hadoop-yarn
            owner   => 'yarn',
            group   => 'mapred',
            mode    => '0755',
            # Make sure HDFS directories are created before
            # resourcemanager is installed and started, but after
            # the namenode.
            require => [Service['hadoop-hdfs-namenode'], puppet-cdh::Cdh5::Hadoop::Directory['/var/log']],
            before  => Package['hadoop-yarn-resourcemanager'],
        }
    }

    package { 'hadoop-yarn-resourcemanager':
        ensure  => 'installed',
    }

    service { 'hadoop-yarn-resourcemanager':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'resourcemanager',
        require    => Package['hadoop-yarn-resourcemanager'],
    }
    
}
