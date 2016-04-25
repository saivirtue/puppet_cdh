# == Class puppet_cdh::cdh::hadoop::nodemanager
# Installs and configures a Hadoop NodeManager worker node.
#
class puppet_cdh::cdh::hadoop::nodemanager inherits puppet_cdh::cdh::hadoop::init {
  if $enabled {
    # package no need remove here, hadoop-hdfs dependency will do the job.
    package { ['hadoop-yarn-nodemanager', 'hadoop-mapreduce']:
      ensure => $ensure,
    }
  }

  # service start/stop is handled by shell
  #    service { 'hadoop-yarn-nodemanager':
  #        ensure     => $enabled,
  #        enable     => $enabled,
  #        hasstatus  => true,
  #        hasrestart => true,
  #        alias      => 'nodemanager',
  #    }
}

