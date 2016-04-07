# === Class: puppet_cdh::cdh::zookeeper::init
#
# The class for install zookeeper. <br/>
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw> <br/>
#
# === Copyright:
#
# Free Usage <br/>
class puppet_cdh::cdh::zookeeper::init inherits puppet_cdh::cdh::zookeeper::params {
  
  Class['puppet_cdh::cdh::repo'] -> Class['puppet_cdh::cdh::zookeeper::init']
  
  define loopZooConf () {
    $hostname_map = split("$name", "[|]")
    $hostname = $hostname_map[0]
    $zid = $hostname_map[1]

    augeas { "add zookeeper hosts in zoo.cfg of $hostname":
      lens    => "Simplevars.lns",
      incl    => '/etc/zookeeper/conf/zoo.cfg',
      changes => [
        "set server.${zid} $hostname:2888:3888",
        "insert #comment before server.${zid}",
        "set #comment[last()] 'zookeeper cluster node:${zid}'"],
    }
  }

  case $ensure {
    /(present)/ : { $enabled = true }
    /(absent)/  : { $enabled = false }
    default     : { fail('ensure parameter must be present or absent') }
  }

  if $enabled {
    package { 'zookeeper':
      ensure => "$ensure",
      tag    => 'cdh-zookeeper',
    } ->
    package { 'zookeeper-server':
      ensure => "$ensure",
      tag    => 'cdh-zookeeper',
    }

    $zookeeper_hosts_array = join_keys_to_values($zookeeper_hosts_hash, "|")

    loopZooConf { $zookeeper_hosts_array: }
    $zid = $zookeeper_hosts_hash["$hostname"]

    exec { 'zookeeper_server_init':
      command => "/sbin/service zookeeper-server init --myid $zid",
      path    => '/usr/bin:/sbin',
      require => [Package['zookeeper'], Package['zookeeper-server'], LoopZooConf[$zookeeper_hosts_array]],
      onlyif  => 'test `find /var/lib/zookeeper -maxdepth 0 -empty`',
    }

    service { 'zookeeper-server':
      ensure  => $enabled,
      enable  => $enabled,
      require => Exec['zookeeper_server_init'],
    }
  } else {
    service { 'zookeeper-server':
      ensure  => $enabled,
      enable  => $enabled,
    } ->
    package { 'zookeeper-server':
      ensure => "$ensure",
      tag    => 'cdh-zookeeper',
    } ->
    package { 'zookeeper':
      ensure => "$ensure",
      tag    => 'cdh-zookeeper',
    } ->
    puppet_cdh::os::directory { '/var/lib/zookeeper': ensure => 'absent', } ->
    puppet_cdh::os::directory { '/var/log/zookeeper': ensure => 'absent', } ->
    puppet_cdh::os::directory { '/etc/zookeeper': ensure => 'absent', }
  }
}