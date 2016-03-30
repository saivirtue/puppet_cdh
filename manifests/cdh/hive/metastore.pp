# == Class puppet_cdh::cdh5::hive::metastore
# Configures hive-metastore.
# See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH5-Installation-Guide/cdh5ig_hive_metastore_configure.html
#
# == Parameters
# $port       - Port on which hive-metastore listens.  Default: undef
# $heapsize   - -Xmx in MB. Default: undef
#
class puppet_cdh::cdh5::hive::metastore(
    $port             = undef,
    $heapsize         = undef,
    $default_template = 'cdh/hive/hive-metastore.default.erb'
)
{
    Class['puppet_cdh::cdh5::hive'] -> Class['puppet_cdh::cdh5::hive::metastore']

    package { 'hive-metastore':
        ensure => 'installed',
    }

    file { '/etc/default/hive-metastore':
        content => template($default_template),
        require => Package['hive-metastore'],
    }

    service { 'hive-metastore':
        ensure     => 'running',
        require    => [
            Package['hive-metastore'],
            File['/etc/default/hive-metastore'],
        ],
        hasrestart => true,
        hasstatus  => true,
    }
}