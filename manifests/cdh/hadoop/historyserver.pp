# == Class puppet_cdh::cdh::hadoop::historyserver
# Installs and starts up a Hadoop YARN HistoryServer.
# This will ensure that the HDFS /user/history exists.
# This class may only be included on the NameNode Master
# Hadoop node.
#
class puppet_cdh::cdh::hadoop::historyserver inherits puppet_cdh::cdh::hadoop::master {
  #    Class['puppet_cdh::cdh::hadoop::namenode'] -> Class['puppet_cdh::cdh::hadoop::resourcemanager']

  if $enabled {
    # Create HistoryServer HDFS directories.
    # See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH5-Installation-Guide/cdh5ig_yarn_cluster_deploy.html?scroll=topic_11_4_9_unique_1
    puppet_cdh::cdh::hadoop::directory { '/user/history':
      owner   => 'yarn',
      group   => 'hdfs',
      mode    => '1777',
      #         before  => Service['hadoop-mapreduce-historyserver'],
      require => [Puppet_cdh::Cdh::Hadoop::Directory['/user'], Service['hadoop-hdfs-namenode']],
    }
    #      Package['hadoop-mapreduce-historyserver'] -> Service['hadoop-mapreduce-historyserver']
  } else {
    #      Service['hadoop-mapreduce-historyserver'] -> Package['hadoop-mapreduce-historyserver']
  }

  package { 'hadoop-mapreduce-historyserver': ensure => $ensure, }

  # service start/stop is handled by shell
  #    service { 'hadoop-mapreduce-historyserver':
  #        ensure     => $enabled,
  #        enable     => $enabled,
  #        hasstatus  => true,
  #        hasrestart => true,
  #        alias      => 'historyserver',
  #    }
}
