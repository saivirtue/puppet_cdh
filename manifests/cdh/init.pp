# == Class: puppet_cdh:init
#
# This class handles installing the Cloudera Distribution, including Apache Hadoop.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# === Actions:
#
# Installs Bigtop, Hadoop, Hue-plugins, HBase, Hive, Oozie, Pig, ZooKeeper, and Flume-NG.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'puppet_cdh::cdh5': }
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw>
#
# === Copyright:
#
# Free Usage
#
class puppet_cdh::cdh::init inherits puppet_cdh::cdh::params {
  # Validate our booleans
  validate_bool($autoupgrade)

#  class { 'puppet_cdh::cdh::hadoop':
#    cluster_name               => 'mycluster',
#    namenode_hosts             => ['puppet-cdh'],
#    dfs_name_dir               => '/var/lib/hadoop/name',
#    datanode_mounts            => '/dfs/dn',
#    yarn_nodemanager_resource_memory_mb      => '6144',
#    yarn_nodemanager_resource_cpu_vcores     => '4',
#    yarn_scheduler_minimum_allocation_mb     => '512',
#    yarn_scheduler_maximum_allocation_mb     => '3072',
#    yarn_scheduler_minimum_allocation_vcores => '1',
#    yarn_scheduler_maximum_allocation_vcores => '4',
#    yarn_app_mapreduce_am_resource_mb        => '1024',
#    yarn_app_mapreduce_am_command_opts       => '-Djava.net.preferIPv4Stack=true -Xmx858993459',
#    mapreduce_map_java_opts    => '-Djava.net.preferIPv4Stack=true -Xmx429496730',
#    mapreduce_reduce_java_opts => '-Djava.net.preferIPv4Stack=true -Xmx858993459',
#    mapreduce_map_memory_mb    => '512',
#    mapreduce_reduce_memory_mb => '1024',
#  }
#
#  class { 'puppet_cdh::cdh5::hadoop::master':
#  }
#
#  class { 'puppet_cdh::cdh5::hadoop::worker':
#  }

  #  class { 'puppet_cdh::cdh5::hue':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::hue::plugins':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
#    class { 'puppet_cdh::cdh5::hbase::master':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
#    }
 #   class { 'puppet_cdh::cdh5::hbase::regionserver':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
#    }
  #  class { 'puppet_cdh::cdh5::hive':
  #    metastore_host => 'puppet-cdh',
  #    zookeeper_hosts => 'puppet-cdh',  
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::oozie':
  #    ensure         => $ensure,
  #    autoupgrade    => $autoupgrade,
  #    service_ensure => $service_ensure,
  #  }
  #  class { 'puppet_cdh::cdh5::pig':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  class { 'puppet_cdh::cdh::zookeeper::init':
  }
  #  class { 'puppet_cdh::cdh5::flume':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::impala':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::search':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::search::lilyhbase':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::crunch':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::hcatalog':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::llama':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::sqoop':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::sqoop2':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet_cdh::cdh5::spark':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
}
