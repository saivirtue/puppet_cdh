# == Define puppet_cdh::cdh5::hadoop::directory
#
# Creates or removes a directory in HDFS.
#
# == Notes:
# This will not check ownership and permissions
# of a directory.  It will only check for the directory's
# existence.  If it does not exist, the directory will be
# created and given specified ownership and permissions.
# This will not attempt to set ownership and permissions
# if the directory already exists.
#
# This define does not support managing files in HDFS,
# only directories.
#
# Ideally this define would be ported into a Puppet File Provider.
# I once spent some time trying to make that work, but it was more
# difficult than it sounds.  For example, you'd need to handle conversion
# between symbolic mode to numeric mode, as I could not find a way to
# get hdfs dfs to list numeric modes for comparison.  Perhaps
# there's a way to use HttpFS to do this instead?
#
# == Parameters:
# $path   - HDFS directory path.   Default: $title
# $ensure - present|absent.        Default: present
# $owner  - HDFS directory owner.  Default: hdfs
# $group  - HDFS directory group owner. Default: hdfs
# $mode   - HDFS diretory mode.  Default 0755
#
define puppet_cdh::cdh5::hbase::directory (
    $path   = $title,
    $ensure = 'present',
    $owner  = 'hbase',
    $group  = 'hbase',
    $mode   = '0755')
{
    Class['puppet_cdh::cdh5::hbase'] -> Puppet_cdh::Cdh5::HBase::Directory[$title]

    if $ensure == 'present' {
        exec { "puppet_cdh::cdh5::hbase::directory ${title}":
            command => "/usr/bin/hdfs dfs -mkdir ${path} && /usr/bin/hdfs dfs -chmod ${mode} ${path} && /usr/bin/hdfs dfs -chown ${owner}:${group} ${path}",
            unless  => [ '[ ! command -v /usr/bin/hdfs ] > /dev/null 2>&1', "/usr/bin/hdfs dfs -test -e ${path}"],
            path    => '/usr/bin:/bin',
            user    => 'hdfs',
        }
    }
    else {
        exec { "puppet_cdh::cdh5::hbase::directory ${title}":
            command => "/usr/bin/hdfs dfs -rm -R ${path}",
            onlyif  => "test -f /usr/bin/hdfs && /usr/bin/hdfs dfs -test -e ${path}",
            user    => 'hdfs',
            require => Service['hadoop-hdfs-namenode'],
        }
    }
}
