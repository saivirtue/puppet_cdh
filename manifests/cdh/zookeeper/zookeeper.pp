# === Class: puppet_cdh::cdh::zookeeper::zookeeper
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
class puppet_cdh::cdh::zookeeper::zookeeper {
  package { 'zookeeper':
    ensure => 'present',
    tag    => 'cdh',
  }
  package { 'zookeeper-server':
    ensure => 'present',
    tag    => 'cdh',
  }
  #use the last ipaddress part : xxx.xxx.xxx.123, 123 as the zid
  $zoo_hosts = ['192.168.1.211','192.168.1.212']
  define loopZooConf {
	  $server_ip = split("$name",'[.]')
	  $zid = $server_ip[-1]
	  augeas {"add zookeeper hosts in zoo.cfg of $name":
	    lens    => "Simplevars.lns",
	    incl    => '/etc/zookeeper/conf/zoo.cfg',
	    changes => ["set server.${zid} $name:2888:3888",
	                "insert #comment before server.${zid}",
	                "set #comment[last()] 'zookeeper cluster node:${zid}'"
	    ],
	  }
	}
	loopZooConf {$zoo_hosts:}
	
  exec { 'zookeeper_server_init':
    command => "/sbin/service zookeeper-server init --myid split($ipaddress,'[.]')[-1]",
    path    => '/usr/bin:/sbin',
    require => [ Package['zookeeper'], Package['zookeeper-server'], ],
    onlyif  => 'test `find /var/lib/zookeeper -maxdepth 0 -empty`',
  }
  service { 'zookeeper-server':
    ensure  => 'running',
    enable  => true,
    require => Exec['zookeeper_server_init'],
  }
}
