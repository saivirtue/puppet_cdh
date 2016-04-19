# == Class: puppet_cdh::cdh::init
#
# This class define the dependency of CDH components.
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw>
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
    #the dependencies is move to hieradata/node/*.yaml part
  } else {
    #because of dependency of cdh, the uninstall order must not change below!
#    Class['puppet_cdh::cdh::hbase::regionserver']
#    ->Class['puppet_cdh::cdh::hbase::master']
#    ->Class['puppet_cdh::cdh::hbase::init']
#    ->Class['puppet_cdh::cdh::hadoop::master']
#    ->Class['puppet_cdh::cdh::hadoop::worker']
#    ->Class['puppet_cdh::cdh::hadoop::init']
#    ->Class['puppet_cdh::cdh::zookeeper::init']
  }
}
