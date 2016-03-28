#
# == Class cdh::hbase
#

class puppet_cdh::cdh5::hbase ($cluster_name = 'mycluster', $hostname = 'puppet_cdh',) {
  $config_directory = "/etc/hbase/conf.${cluster_name}"
  $service_name = 'hbase'

  file { "/etc/security/limits.d/hbase.conf": content => template('puppet_cdh/os/ulimits.conf.erb'), }

  # sudo -u hdfs hdfs dfs -mkdir /tmp
  # sudo -u hdfs hdfs dfs -chmod 1777 /tmp
  puppet_cdh::cdh5::hadoop::directory { '/hbase':
    owner => 'hbase',
    group => 'hbase',
    mode  => '0755',
  }
}
