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
  class { 'puppet-cdh':
    install_cmserver => false,
    use_parcels      => false,
    ensure           => present,
  }
}
