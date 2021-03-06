# == Class: puppet_cdh::cdh::init
#
# This class handles installing the Cloudera Distribution, including Apache Hadoop.
#
# === Parameters:
#
# === Actions:
#
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw>
#
# === Copyright:
#
# Free Usage
#
class puppet_cdh::cdh::init inherits puppet_cdh::params {

  # Install a serviceAdmin script, this can be userd to start|stop|status services.
  file { '/usr/local/bin/serviceAdmin.sh':
    ensure => $ensure,
    source => 'puppet:///modules/puppet_cdh/serviceAdmin.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

  if $enabled {
#	  include puppet_cdh::cdh::hadoop::init
#	  include puppet_cdh::cdh::hadoop::master
#	  include puppet_cdh::cdh::hadoop::worker
#	  include puppet_cdh::cdh::hbase::init
#	  include puppet_cdh::cdh::hbase::master
#	  include puppet_cdh::cdh::hbase::regionserver
#	  include puppet_cdh::cdh::zookeeper::init
  } else {
#    include puppet_cdh::cdh::hadoop::init
#    include puppet_cdh::cdh::hadoop::master
#    include puppet_cdh::cdh::hadoop::worker
#    include puppet_cdh::cdh::hbase::init
#    include puppet_cdh::cdh::hbase::master
#    include puppet_cdh::cdh::hbase::regionserver
#    include puppet_cdh::cdh::zookeeper::init
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
