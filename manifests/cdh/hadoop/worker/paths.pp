# == Define puppet_cdh::cdh5::hadoop::worker::paths
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
# puppet_cdh::cdh5::hadoop::worker::paths { ['/mnt/hadoop/data/a', '/mnt/hadoop/data/b']: }
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
define puppet_cdh::cdh5::hadoop::worker::paths ($basedir = $title) {
  Class['puppet_cdh::cdh5::hadoop'] -> Puppet_cdh::Cdh5::Hadoop::Worker::Paths[$title]

  # hdfs, hadoop, and yarn users
  # are all added by packages
  # installed by puppet_cdh::cdh5::hadoop

  # make sure mounts exist
  file { $basedir:
    ensure  => 'directory',
    owner   => 'hdfs',
    group   => 'hdfs',
    mode    => '0755',
    require => Exec["create_$basedir"],
  }

  exec { "create_$basedir":
    command  => "mkdir -p $basedir",
    path     => '/bin',
    provider => 'shell',
    unless   => "test -d $basedir",
  }

  # Assume that $dfs_data_path is two levels.  e.g. hdfs/dn
  # We need to manage the parent directory too.
  $dfs_data_path_parent = inline_template("<%= File.dirname('${::puppet_cdh::cdh5::hadoop::dfs_data_path}') %>")

  # create DataNode directories
  file { ["${basedir}/${dfs_data_path_parent}", "${basedir}/${::puppet_cdh::cdh5::hadoop::dfs_data_path}"]:
    ensure  => 'directory',
    owner   => 'hdfs',
    group   => 'hdfs',
    mode    => '0700',
    require => File[$basedir],
  }

  # create yarn local directories
  file { ["${basedir}/yarn", "${basedir}/yarn/local", "${basedir}/yarn/logs"]:
    ensure => 'directory',
    owner  => 'yarn',
    group  => 'yarn',
    mode   => '0755',
  }
}
