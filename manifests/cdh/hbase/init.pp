# === Class: puppet_cdh::cdh::hbase::init
#
# The class for install hbase. <br/>
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw> <br/>
#
# === Copyright:
#
# Free Usage <br/>
class puppet_cdh::cdh::hbase::init inherits puppet_cdh::cdh::hbase::params {
  $config_directory = "/etc/hbase/conf.${cluster_name}"
  $service_name = 'hbase'
  $zookeeper_hosts_array = keys($zookeeper_hosts_hash)
  $zookeeper_hosts = join($zookeeper_hosts_array,",")
  
  if !$enabled {
    #this will ensure any unused files and folders being removed. (need to move other place?)
    $remove_dirs = ["/var/lib/hbase*","/var/log/hbase*"]
    puppet_cdh::os::directory {$remove_dirs: ensure => $ensure}
  }
  
  file { ['/etc/hbase','/etc/hbase/conf']:
    ensure  => $dir_enabled,
    force   => true,
  }

  if $enabled {
	  file { "/etc/security/limits.d/hbase.conf": content => template('puppet_cdh/os/ulimits.conf.erb'), }
	  file { "/etc/hbase/conf/hbase-site.xml": content => template('puppet_cdh/hbase/hbase-site.xml.erb'), }
  }
}
