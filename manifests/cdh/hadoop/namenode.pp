# == Class puppet_cdh::cdh::hadoop::namenode
# Installs and configureds Hadoop NameNode.
# This will format the NameNode if it is not
# already formatted.  It will also create
# a common HDFS directory hierarchy.
#
# Note:  If you are using HA NameNode (indicated by setting
# puppet_cdh::cdh::hadoop::init::nameservice_id), your JournalNodes should be running before
# this class is applied.
#
class puppet_cdh::cdh::hadoop::namenode inherits puppet_cdh::cdh::hadoop::init {
  if $enabled {
    Package['hadoop-hdfs-namenode'] -> File[$dfs_name_dir] -> Exec['touch hosts.exclude'] -> Exec['hadoop-namenode-format'] -> Service['hadoop-hdfs-namenode']

  } else {
    Service['hadoop-hdfs-namenode'] -> File[$dfs_name_dir] -> Package['hadoop-hdfs-namenode']
  }

  # install namenode daemon package
  package { 'hadoop-hdfs-namenode': ensure => $ensure, }

  if $enabled {
    # NameNodes expect that the hosts.exclude file exists.
    # I don't want to manage this as a puppet file resource,
    # as users of this class might want to manage it themselves.
    # Instead, this exec just touches the file if it doesn't exist.
    exec { 'touch hosts.exclude':
      command => "touch ${config_directory}/hosts.exclude",
      unless  => "test -f ${config_directory}/hosts.exclude",
    }
    
    # If $dfs_name_dir/current/VERSION doesn't exist, assume
    # NameNode has not been formated.  Format it before
    # the namenode service is started.
    # namenode-format only execute if the ${dfs_name_dir_main} exists (not uninstall case).
    exec { 'hadoop-namenode-format':
      command => 'hdfs namenode -format -nonInteractive',
      creates => "${dfs_name_dir_main}/current/VERSION",
      onlyif  => "test -d ${dfs_name_dir_main}",
      user    => 'hdfs',
    }
  }

  # Ensure that the namenode directory has the correct permissions.
  file { $dfs_name_dir:
    ensure => $dir_enabled,
    force  => true,
    owner  => 'hdfs',
    group  => 'hdfs',
    mode   => '0700',
  }

  # namenode need to be started from puppet for create hdfs directories
  service { 'hadoop-hdfs-namenode':
    ensure     => $enabled,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    alias      => 'namenode',
  }
}
