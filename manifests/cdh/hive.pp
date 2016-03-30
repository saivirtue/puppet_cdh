# == Class puppet_cdh::cdh5::hive
#
# Installs Hive packages (needed for Hive Client).
# Use this in conjunction with puppet_cdh::cdh5::hive::master to install and set up a
# Hive Server and Hive Metastore.
# This also installs hive-hcatalog
#
# == Parameters
# $metastore_host                - fqdn of the metastore host
# $zookeeper_hosts               - Array of zookeeper hostname/IP(:port)s.
#                                  Default: undef (zookeeper lock management
#                                  will not be used).
#
# $support_concurrency           - Whether Hive supports concurrency or not. A Zookeeper
#                                  instance must be up and running for the default Hive
#                                  lock manager to support read-write locks.
#                                  Default: true if $zookeeper_hosts is set, false if not.
#
# $jdbc_database                 - Metastore JDBC database name.
#                                  Default: 'hive_metastore'
# $jdbc_username                 - Metastore JDBC username.  Default: hive
# $jdbc_password                 - Metastore JDBC password.  Default: hive
# $jdbc_host                     - Metastore JDBC hostname.  Default: localhost
# $jdbc_port                     - Metastore JDBC port.      Default: 3306
# $jdbc_driver                   - Metastore JDBC driver class name.
#                                  Default: org.apache.derby.jdbc.EmbeddedDriver
# $jdbc_protocol                 - Metastore JDBC protocol.  Default: mysql
#
#                                  Only set these if your root user cannot issue database
#                                  commands without a different username and password.
#                                  Default: undef
# $variable_substitute_depth     - The maximum replacements the substitution engine will do. Default: undef
#
# $auxpath                       - Additional path to pass to hive.  Default: undef
# $parquet_compression           - Compression type for parquet-format to use.  It will
#                                  ignore mapreduce_output_compession_codec.  Set this to
#                                  one of UNCOMPRESSED, SNAPPY, GZIP.  Default: undef
# $exec_parallel_thread_number   - Number of jobs at most can be executed in parallel.
#                                  Set this to 0 to disable parallel execution.
# $optimize_skewjoin             - Enable or disable skew join optimization.
#                                  Default: false
# $skewjoin_key                  - Number of rows where skew join is used.
#                                - Default: 10000
# $skewjoin_mapjoin_map_tasks    - Number of map tasks used in the follow up
#                                  map join jobfor a skew join.   Default: 10000.
# $skewjoin_mapjoin_min_split    - Skew join minimum split size.  Default: 33554432
#
# $stats_enabled                 - Enable or disable temp Hive stats.  Default: false
# $stats_dbclass                 - The default database class that stores
#                                  temporary hive statistics.  Default: jdbc:derby
# $stats_jdbcdriver              - JDBC driver for the database that stores
#                                  temporary hive statistics.
#                                  Default: org.apache.derby.jdbc.EmbeddedDriver
# $stats_dbconnectionstring      - Connection string for the database that stores
#                                  temporary hive statistics.
#                                  Default: jdbc:derby:;databaseName=TempStatsStore;create=true
#
class puppet_cdh::cdh5::hive(
    $metastore_host,
    $zookeeper_hosts             = $puppet_cdh::cdh5::hive::defaults::zookeeper_hosts,
    $support_concurrency         = $puppet_cdh::cdh5::hive::defaults::support_concurrency,
    $jdbc_database               = $puppet_cdh::cdh5::hive::defaults::jdbc_database,
    $jdbc_username               = $puppet_cdh::cdh5::hive::defaults::jdbc_username,
    $jdbc_password               = $puppet_cdh::cdh5::hive::defaults::jdbc_password,
    $jdbc_host                   = $puppet_cdh::cdh5::hive::defaults::jdbc_host,
    $jdbc_port                   = $puppet_cdh::cdh5::hive::defaults::jdbc_port,
    $jdbc_driver                 = $puppet_cdh::cdh5::hive::defaults::jdbc_driver,
    $jdbc_protocol               = $puppet_cdh::cdh5::hive::defaults::jdbc_protocol,

    $variable_substitute_depth   = $puppet_cdh::cdh5::hive::defaults::variable_substitute_depth,
    $auxpath                     = $puppet_cdh::cdh5::hive::defaults::auxpath,
    $parquet_compression         = $puppet_cdh::cdh5::hive::defaults::parquet_compression,

    $exec_parallel_thread_number = $puppet_cdh::cdh5::hive::defaults::exec_parallel_thread_number,
    $optimize_skewjoin           = $puppet_cdh::cdh5::hive::defaults::optimize_skewjoin,
    $skewjoin_key                = $puppet_cdh::cdh5::hive::defaults::skewjoin_key,
    $skewjoin_mapjoin_map_tasks  = $puppet_cdh::cdh5::hive::defaults::skewjoin_mapjoin_map_tasks,

    $stats_enabled               = $puppet_cdh::cdh5::hive::defaults::stats_enabled,
    $stats_dbclass               = $puppet_cdh::cdh5::hive::defaults::stats_dbclass,
    $stats_jdbcdriver            = $puppet_cdh::cdh5::hive::defaults::stats_jdbcdriver,
    $stats_dbconnectionstring    = $puppet_cdh::cdh5::hive::defaults::stats_dbconnectionstring,

    $hive_site_template          = $puppet_cdh::cdh5::hive::defaults::hive_site_template,
    $hive_log4j_template         = $puppet_cdh::cdh5::hive::defaults::hive_log4j_template,
    $hive_exec_log4j_template    = $puppet_cdh::cdh5::hive::defaults::hive_exec_log4j_template
) inherits puppet_cdh::cdh5::hive::defaults
{
    Class['puppet_cdh::cdh5::hadoop'] -> Class['puppet_cdh::cdh5::hive']

    package { 'hive':
        ensure => 'installed',
    }
    $config_directory = "/etc/hive/conf.${puppet_cdh::cdh5::hadoop::cluster_name}"
    # Create the $cluster_name based $config_directory.
    file { $config_directory:
        ensure  => 'directory',
        require => Package['hive'],
    }
    puppet_cdh::cdh5::alternative { 'hive-conf':
        link => '/etc/hive/conf',
        path => $config_directory,
    }

    # If we need more hcatalog services
    # (e.g. webhcat), this may be moved
    # to a class of its own.
    package { 'hive-hcatalog':
        ensure  => 'installed',
        require => Package['hive'],
    }

    # Make sure hive-site.xml is not world readable on the
    # metastore host.  On the metastore host, hive-site.xml
    # will contain database connection credentials.
    $hive_site_mode = $metastore_host ? {
        $::fqdn => '0440',
        default => '0444',
    }
    file { "${config_directory}/hive-site.xml":
        content => template($hive_site_template),
        mode    => $hive_site_mode,
        owner   => 'hive',
        group   => 'hive',
        require => Package['hive'],
    }
    file { "${config_directory}/hive-log4j.properties":
        content => template($hive_log4j_template),
        require => Package['hive'],
    }
    file { "${config_directory}/hive-exec-log4j.properties":
        content => template($hive_exec_log4j_template),
        require => Package['hive'],
    }
}
