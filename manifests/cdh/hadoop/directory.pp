# == Define puppet_cdh::cdh::hadoop::directory
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
define puppet_cdh::cdh::hadoop::directory (
    $path   = $title,
    $ensure = 'present',
    $owner  = 'hdfs',
    $group  = 'hdfs',
    $mode   = '0755')
{
    Class['puppet_cdh::cdh::hadoop::init'] -> Puppet_cdh::Cdh::Hadoop::Directory[$title]
    
    if $ensure == 'present' {    
        exec { "puppet_cdh::cdh::hadoop::directory ${title}":
            command => "hdfs dfs -mkdir ${path} && hdfs dfs -chmod ${mode} ${path} && hdfs dfs -chown ${owner}:${group} ${path}",
            unless  => ["hdfs dfs -test -e ${path}"],
            require => Exec['check_hdfs_command_exists'],
            user    => 'hdfs',
        }
    }
    else {
        #since uninstall no need to remove hdfs data (file remove will handle this)
        #comment this part for no usage
#        exec { "puppet_cdh::cdh::hadoop::directory ${title}":
#            command => "/usr/bin/hdfs dfs -rm -R ${path}",
#            onlyif  => "test -f /usr/bin/hdfs && /usr/bin/hdfs dfs -test -e ${path}",
#            path    => '/usr/bin:/bin',
#            user    => 'hdfs',
#        }
    }
}
