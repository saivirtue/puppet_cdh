# == Class puppet_cdh::cdh::hadoop::resourcemanager
# Installs and configures Hadoop YARN ResourceManager.
# This will create YARN HDFS directories.
#
class puppet_cdh::cdh::hadoop::resourcemanager inherits puppet_cdh::cdh::hadoop::master {
  #    Class['puppet_cdh::cdh::hadoop::namenode::primary'] -> Class['puppet_cdh::cdh::hadoop::resourcemanager']

  if $enabled {
    #      Package['hadoop-yarn-resourcemanager'] -> Service['hadoop-yarn-resourcemanager']
    # make nproc limits file
    $service_name = 'yarn'

    file { "/etc/security/limits.d/yarn.conf": content => template('puppet_cdh/os/ulimits.conf.erb'), }
  } else {
    #      Service['hadoop-yarn-resourcemanager'] -> Package['hadoop-yarn-resourcemanager']
  }

  # In an HA YARN ResourceManager setup, this class will be included on multiple nodes.
  # In order to have this directory check performed by only one resourcemanager,
  # we only use it on the first node in the $resourcemanager_hosts array.
  # This means that the Hadoop Master NameNode must be the same node as the
  # Hadoop Master ResouceManager.
  if $enabled and (!$yarn_ha_enabled or $::fqdn == $primary_resourcemanager_host) {
    # Create YARN HDFS directories.
    # See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH5-Installation-Guide/cdh5ig_yarn_cluster_deploy.html?scroll=topic_11_4_10_unique_1
    puppet_cdh::cdh::hadoop::directory { '/var/log/hadoop-yarn':
      # sudo -u hdfs hdfs dfs -mkdir /var/log/hadoop-yarn
      # sudo -u hdfs hdfs dfs -chown yarn:mapred /var/log/hadoop-yarn
      owner => 'yarn',
      group => 'mapred',
      mode  => '0755',
      require => Service['hadoop-hdfs-namenode'],
    #            before  => Service['hadoop-yarn-resourcemanager'], #  Make sure HDFS directories are created before resourcemanager .
    }
  }

  package { 'hadoop-yarn-resourcemanager': ensure => $ensure, }

  # service start/stop is handled by shell
  #    service { 'hadoop-yarn-resourcemanager':
  #        ensure     => $enabled,
  #        enable     => $enabled,
  #        hasstatus  => true,
  #        hasrestart => true,
  #        alias      => 'resourcemanager',
  #    }
}
