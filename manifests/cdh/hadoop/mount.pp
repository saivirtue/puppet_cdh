# == Class puppet_cdh::cdh::hadoop::mount
# Mounts the HDFS filesystem at $mount_point using hadoop-hdfs-fuse.
#
# See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH5-Installation-Guide/cdh5ig_hdfs_mountable.html
#
# == Parameters
# $mount_point       - Path at which HDFS should be mounted.  This path will be
#                      ensured to be a directory.  Default: /mnt/hdfs
# $read_only         - If false, mount will be writeable.  Default: true
#
class puppet_cdh::cdh::hadoop::mount(
    $mount_point     = '/mnt/hdfs',
    $read_only       = true,
)
{
    Class['puppet_cdh::cdh::hadoop::init'] -> Class['puppet_cdh::cdh::hadoop::mount']

    package { 'hadoop-hdfs-fuse':
        ensure => 'installed',
    }

    $device = $ha_enabled ? {
        true    => "hadoop-fuse-dfs#dfs://${nameservice_id}",
        default => "hadoop-fuse-dfs#dfs://${primary_namenode_host}:8020",
    }

    $options = $read_only ? {
        true    => 'allow_other,usetrash,ro',
        default => 'allow_other,usetrash,rw',
    }

    # Create the mount point if it doesn't exist.
    #
    # If Fuse ever looses its connection to the
    # NameNode, it seems that the mount will be
    # left in a weird state.  When the NameNode
    # comes back online, the mount will be just fine.
    # However, during the period that the NameNode
    # is offline, puppet will fail if we were to
    # try to ensure => 'directory' on $mount_point
    # as a File resource.  If we were to require
    # this as a File resource, puppet would never
    # attempt to remount after a NameNode failure,
    # because the File resource would fail until
    # the mount is remounted.
    #
    #   Error: Could not set 'directory' on ensure: File exists - /mnt/hdfs at 36:/etc/puppet/modules/cdh/manifests/hadoop/mount.pp
    #   ...
    #   Warning: /Stage[main]/Cdh::Hadoop::Mount/Mount[hdfs-fuse]: Skipping because of failed dependencies
    #
    # We can't even use unless => "test -d ${mount_point}"
    # in an exec, because that will fail too.
    # Instead, we parse the output of ls. :(
    exec { 'mkdir_hdfs_mount_point':
        command => "/bin/mkdir -p ${mount_point}",
        unless  => "ls $(/usr/bin/dirname ${mount_point}) 2> /dev/null | grep -q $(/usr/bin/basename ${mount_point})",
    }

    mount { 'hdfs-fuse':
        ensure   => 'mounted',
        device   => $device,
        name     => $mount_point,
        fstype   => 'fuse',
        options  => $options,
        dump     => '0',
        pass     => '0',
        remounts => false,
        require  => [Package['hadoop-hdfs-fuse'], Exec['mkdir_hdfs_mount_point']],
    }
}
