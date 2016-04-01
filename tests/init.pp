node 'puppet-cdh' {
  #install CM Server
  /*
  class { 'cloudera':
    install_cmserver => true,
    cm_server_host => 'localhost',
    ensure => absent,
  }
  */
  
  #install CDH packages
  class{ 'puppet_cdh::params':
    #top scope
    use_package      => true,
    ensure           => absent,
    cdh_version      => '5',
    #zookeeper scope
    zookeeper_hosts_hash => {'puppet-cdh' => '1','server-b1' => '2'}, #must specify with : hostname => zid
  }
  class { 'puppet_cdh': 
  }

#include puppet_cdh::params
#Package["ruby-augeas"] -> Augeas <| |>

#  notify{'test get local variable':
#    message => "$puppet_cdh::cdh::hadoop::params::cluster_name",
#  }
  
#  include puppet_cdh::cdh::zookeeper
}
