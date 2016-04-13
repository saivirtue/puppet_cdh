# == Define puppet_cdh::cdh::hadoop::worker::paths
#
# Ensures directories needed for Hadoop Worker nodes
# are created with proper ownership and permissions.
# This has to be a define so that we can pass the
# $datanode_mounts array as a group.  (Puppet doesn't
# support iteration.)
#
# You should probably create each $basedir yourself before you
# this define is used.  Each $basedir is expected to be a JBOD
# mount point that Hadoop will use to store data in.  This define
# does not manage creating or mounting any partitions.
#
# == Parameters:
# $basedir   - base path for directory creation.  Default: $title
#
# == Usage:
# puppet_cdh::cdh::hadoop::worker::paths { ['/mnt/hadoop/data/a', '/mnt/hadoop/data/b']: }
#
# The above declaration will ensure that the following directory hierarchy exists:
#       /mnt/hadoop/data/a
#       /mnt/hadoop/data/a/hdfs
#       /mnt/hadoop/data/a/hdfs/dn
#       /mnt/hadoop/data/a/yarn
#       /mnt/hadoop/data/a/yarn/local
#       /mnt/hadoop/data/a/yarn/logs
#       /mnt/hadoop/data/b
#       /mnt/hadoop/data/b/hdfs
#       /mnt/hadoop/data/b/hdfs/dn
#       /mnt/hadoop/data/b/yarn
#       /mnt/hadoop/data/b/yarn/local
#       /mnt/hadoop/data/b/yarn/logs
#
# (If you use MRv1 instead of yarn, the hierarchy will be slightly different.)
#
define puppet_cdh::cdh::hadoop::worker::paths (
  $basedir = $title,
  $ensure, # true or false
  $dfs_data_path,
  $yarn_local_path,
  $yarn_logs_path
) {
  
  if $ensure {
    Exec["create_$basedir"] -> File[$basedir]
  }

  case $ensure {
    true    : { $dir_enabled = 'directory' }
    false   : { $dir_enabled = 'absent' }
    default : { fail('ensure parameter must be true or false') }
  }

  # hdfs, hadoop, and yarn users
  # are all added by packages
  # installed by puppet_cdh::cdh::hadoop::init

  # make sure mounts exist
  file { $basedir:
    ensure  => $dir_enabled,
    force   => true,
    owner   => 'hdfs',
    group   => 'hdfs',
    mode    => '0755',
  }

  if $ensure {
	  exec { "create_$basedir":
	    command  => "mkdir -p $basedir",
	    provider => 'shell',
	    unless   => "test -d $basedir",
	  }
	
	  # Assume that $dfs_data_path is two levels.  e.g. hdfs/dn
	  # We need to manage the parent directory too.
	  # $dfs_data_path_parent could be an array.
	  $dfs_data_path_parent = inline_template("<%= File.dirname('${dfs_data_path}') %>")
	
	  # create DataNode directories
	  file { ["${basedir}/${dfs_data_path_parent}", "${basedir}/${dfs_data_path}"]:
	    ensure  => 'directory',
	    owner   => 'hdfs',
	    group   => 'hdfs',
	    mode    => '0700',
	    require => File[$basedir],
	  }
	
	  # create yarn local and log directories
	  file { ["${basedir}/yarn", "${basedir}/${yarn_local_path}", "${basedir}/${yarn_logs_path}"]:
	    ensure => 'directory',
	    owner  => 'yarn',
	    group  => 'yarn',
	    mode   => '0755',
	    require => File[$basedir],
	  }
  }
}
