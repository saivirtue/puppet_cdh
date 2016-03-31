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
#  class { 'puppet_cdh':
#    install_cmserver => false,
#    use_parcels      => false,
#    ensure           => present,
#  }

include puppet_cdh::params
#Package["ruby-augeas"] -> Augeas <| |>

  notify{'test get local variable':
    message => "$puppet_cdh::cdh::hadoop::params::cluster_name",
  }
  
  include puppet_cdh::cdh::zookeeper::zookeeper
}
