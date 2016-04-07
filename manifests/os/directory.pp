# == Define puppet_cdh::os::directory
#
# Creates or removes a directory in OS.
#
# == Parameters:
# $path   - HDFS directory path.   Default: $title
# $ensure - present|absent.        Default: present
# $owner  - HDFS directory owner.  Default: hdfs
# $group  - HDFS directory group owner. Default: hdfs
# $mode   - HDFS diretory mode.  Default 0755
#
define puppet_cdh::os::directory (
    $path   = $title,
    $ensure = 'present',
    $owner  = 'root',
    $group  = 'root',
    $mode   = '0755')
{
    if $ensure == 'present' {
        exec { "puppet_cdh::os::directory Create ${title}":
            command => "/bin/mkdir -p ${path} && /bin/chmod ${mode} ${path} && /bin/chown ${owner}:${group} ${path}",
            unless  => "/usr/bin/test -e ${path}",
            path    => '/bin:/usr/bin',
            user    => 'root',
        }
    }
    else {
        exec { "puppet_cdh::os::directory Remove ${title}":
            command => "/bin/rm -rf ${path}",
            onlyif  => "test -e ${path}",
            path    => '/bin:/usr/bin',
            user    => 'root',
        }
    }
}
