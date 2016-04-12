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
class puppet_cdh::cdh::init(
  $install_master,
  $install_slave,
) inherits puppet_cdh::params {

  if $enabled {
	  include puppet_cdh::cdh::hadoop::init
	  include puppet_cdh::cdh::hadoop::master
	  include puppet_cdh::cdh::hadoop::worker
	  include puppet_cdh::cdh::hbase::init
	  include puppet_cdh::cdh::hbase::master
	  include puppet_cdh::cdh::hbase::regionserver
	  include puppet_cdh::cdh::zookeeper::init
    Class['puppet_cdh::cdh::zookeeper::init']
    ->Class['puppet_cdh::cdh::hadoop::init']
    ->Class['puppet_cdh::cdh::hadoop::master']
    ->Class['puppet_cdh::cdh::hadoop::worker']
    ->Class['puppet_cdh::cdh::hbase::init']
    ->Class['puppet_cdh::cdh::hbase::master']
    ->Class['puppet_cdh::cdh::hbase::regionserver']
  } else {
    include puppet_cdh::cdh::hadoop::init
    include puppet_cdh::cdh::hadoop::master
    include puppet_cdh::cdh::hadoop::worker
    include puppet_cdh::cdh::hbase::init
    include puppet_cdh::cdh::hbase::master
    include puppet_cdh::cdh::hbase::regionserver
    include puppet_cdh::cdh::zookeeper::init
    #puppet_cdh::cdh::hadoop::worker is NO need to remove pacakge, because purging hadoop-client will handle it.
    #because of dependency of cdh, the uninstall order must not change below!
    Class['puppet_cdh::cdh::hbase::regionserver']
    ->Class['puppet_cdh::cdh::hbase::master']
    ->Class['puppet_cdh::cdh::hbase::init']
    ->Class['puppet_cdh::cdh::hadoop::master']
    ->Class['puppet_cdh::cdh::hadoop::worker']
    ->Class['puppet_cdh::cdh::hadoop::init']
    ->Class['puppet_cdh::cdh::zookeeper::init']
  }

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
  #    metastore_host => 'puppetmaster',
  #    zookeeper_hosts => 'puppetmaster',  
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
