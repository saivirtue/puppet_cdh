# == Define cdh::hive::metastore::mysql::grant
# Adds an additional grant for $cdh::hive::jdbc_username to
# allow connecting from a remote host.
#
# This does not create a new user or password, it just allows
# a remote host to connect to MySQL via the already configured
# user.  This is useful if running hive-metastore daemon on a node
# other than the MySQL host.
#
# == Usage:
# cdh::hive::metastore::mysql::grant { 'myotherhost.example.org': }
#
define puppet_cdh::cdh::hive::metastore::mysql::grant($allowed_host = $title) {
    Class['puppet_cdh::cdh::hive::metastore::mysql'] -> Puppet_cdh_::Cdh::Hive::Metastore::Mysql::Grant[$title]

    $jdbc_database = $puppet_cdh::cdh::hive::metastore::mysql::jdbc_database
    $jdbc_username = $puppet_cdh::cdh::hive::metastore::mysql::jdbc_username
    $jdbc_password = $puppet_cdh::cdh::hive::metastore::mysql::jdbc_password

    # Only use -u or -p flag to mysql commands if
    # root username or root password are set.
    $username_option = $puppet_cdh::cdh::hive::metastore::mysql::db_root_username ? {
        undef   => '',
        default => "-u'${puppet_cdh::cdh::hive::metastore::mysql::db_root_username}'",
    }
    $password_option = $puppet_cdh::cdh::hive::metastore::mysql::db_root_password ? {
        undef   => '',
        default => "-p'${puppet_cdh::cdh::hive::metastore::mysql::db_root_password}'",
    }

    exec { "hive_mysql_grant_${allowed_host}":
        command => "/usr/bin/mysql ${username_option} ${password_option} -e \"
GRANT ALL PRIVILEGES ON ${jdbc_database}.* TO '${jdbc_username}'@'${allowed_host}' IDENTIFIED BY '${jdbc_password}';
FLUSH PRIVILEGES;\"",
        unless  => "/usr/bin/mysql ${username_option} ${password_option} -e \"SHOW GRANTS FOR '${jdbc_username}'@'${allowed_host}'\" | grep -q \"TO '${jdbc_username}'\"",
        user    => 'root',
    }
}
