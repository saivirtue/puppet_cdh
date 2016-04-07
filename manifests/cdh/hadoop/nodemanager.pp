# == Class puppet_cdh::cdh::hadoop::nodemanager
# Installs and configures a Hadoop NodeManager worker node.
#
class puppet_cdh::cdh::hadoop::nodemanager inherits puppet_cdh::cdh::hadoop::worker {
  
    if $enabled {
      Package['hadoop-yarn-nodemanager','hadoop-mapreduce'] -> Service['hadoop-yarn-nodemanager']
    } else {
      Service['hadoop-yarn-nodemanager'] -> Package['hadoop-yarn-nodemanager','hadoop-mapreduce']
    }

    package { ['hadoop-yarn-nodemanager', 'hadoop-mapreduce']:
        ensure => $ensure,
    }

    service { 'hadoop-yarn-nodemanager':
        ensure     => $enabled,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'nodemanager',
    }
}

