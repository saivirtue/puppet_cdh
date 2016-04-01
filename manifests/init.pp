# == Class: puppet_cdh
#
# The main class for installing CM and CDH
#
# === Requires:
#
# === Sample Usage:
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw>
#
# === Copyright:
#
# Free Usage
#
class puppet_cdh inherits puppet_cdh::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($use_package)
  validate_bool($install_lzo)
  validate_bool($install_java)
  validate_bool($install_jce)
  
  stage {'check':}
  Stage['check'] -> Stage['main']

  exec { 'set_vm_swappiness':
    command  => 'sysctl -w vm.swappiness=0',
    unless   => 'test 0 -eq `sysctl -n vm.swappiness`',
    path     => '/sbin',
    provider => 'shell',
  } ->
  exec { 'disable_transparent_hugepage_defrag':
    command  => 'if [ -f /sys/kernel/mm/transparent_hugepage/defrag ]; then echo never > /sys/kernel/mm/transparent_hugepage/defrag; fi',
    unless   => 'if [ -f /sys/kernel/mm/transparent_hugepage/defrag ]; then grep -q "\[never\]" /sys/kernel/mm/transparent_hugepage/defrag; fi',
    path     => '/usr/bin:/usr/sbin:/bin:/sbin',
    provider => 'shell',
  } ->
  exec { 'disable_redhat_transparent_hugepage_defrag':
    command  => 'if [ -f /sys/kernel/mm/redhat_transparent_hugepage/defrag ]; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag; fi',
    unless   => 'if [ -f /sys/kernel/mm/redhat_transparent_hugepage/defrag ]; then grep -q "\[never\]" /sys/kernel/mm/redhat_transparent_hugepage/defrag; fi',
    path     => '/usr/bin:/usr/sbin:/bin:/sbin',
    provider => 'shell',
  } ->
  # Configuring Dependencies Before Install Cluster
  package { 'ntp': ensure => 'present', }
  service { 'ntpd':
    ensure    => 'running',
    enable    => true,
    hasstatus => true,
    require   => Package['ntp'],
  } ->
  exec { 'ntp_sync':
    command => 'ntpdate -u pool.ntp.org',
    path    => '/usr/sbin',
    require => Service['ntpd'],
  }

  # TODO : hostname check ?
  # http://www.cloudera.com/documentation/enterprise/latest/topics/cdh_ig_networknames_configure.html
  # TODO : check selinux is disabled
  # getenforce should be false
  # setenforce 0
  # TODO : disable iptables
  # iptables-save > /root/firewall.rules
  # /etc/init.d/iptables stop ; chkconfig iptables off

  if $install_java {
    include puppet_cdh::java::repo
    include puppet_cdh::java::init
    Class['puppet_cdh::java::repo'] -> Class['puppet_cdh::java::init']
  }

  if $install_jce {
    class { 'puppet_cdh::java::jce':
      ensure  => $ensure,
      require => Class['puppet_cdh::java::init'],
    }
  }

  # Installing the CDH RPMs if we are going to use parcels.
  if $use_package {
    if $cdh_version =~ /^5/ {
      class { 'puppet_cdh::cdh::repo':
      }
      class { 'puppet_cdh::cdh::init':
      }
      Class['puppet_cdh::cdh::repo'] -> Class['puppet_cdh::cdh::init']
      #        if $install_lzo {
      #          if $cg_version !~ /^5/ {
      #            fail('Parameter $cg_version must be 5 if $cdh_version is 5.')
      #          }
      #          class { 'puppet_cdh::gplextras5::repo':
      #            ensure         => $ensure,
      #            reposerver     => $cg_reposerver,
      #            repopath       => $cg5_repopath,
      #            version        => $cg_version,
      #            proxy          => $proxy,
      #            proxy_username => $proxy_username,
      #            proxy_password => $proxy_password,
      #            #require        => Anchor['puppet_cdh::begin'],
      #            #before         => Anchor['puppet_cdh::end'],
      #          }
      #          class { 'puppet_cdh::gplextras5':
      #            ensure      => $ensure,
      #            autoupgrade => $autoupgrade,
      #            #require     => Anchor['puppet_cdh::begin'],
      #            #before      => Anchor['puppet_cdh::end'],
      #          }
      #        }
    } else {
      fail('Parameter $cdh_version must start with either 4 or 5.')
    }
  }
}
