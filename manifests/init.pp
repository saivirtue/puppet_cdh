# == Class: puppet_cdh
#
# The main class for installing CDH
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw>
#
class puppet_cdh inherits puppet_cdh::params {
  # Validate booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($install_lzo)
  validate_bool($install_java)
  validate_bool($install_jce)

  # java class must be installed first
  stage { 'first': }
  Stage['first'] -> Stage['main']

  if $enabled {
    exec { 'set_vm_swappiness':
      command  => 'sysctl -w vm.swappiness=0',
      unless   => 'test 0 -eq `sysctl -n vm.swappiness`',
      provider => 'shell',
    } ->
    exec { 'disable_transparent_hugepage_defrag':
      command  => 'if [ -f /sys/kernel/mm/transparent_hugepage/defrag ]; then echo never > /sys/kernel/mm/transparent_hugepage/defrag; fi',
      unless   => 'if [ -f /sys/kernel/mm/transparent_hugepage/defrag ]; then grep -q "\[never\]" /sys/kernel/mm/transparent_hugepage/defrag; fi',
      provider => 'shell',
    } ->
    exec { 'disable_redhat_transparent_hugepage_defrag':
      command  => 'if [ -f /sys/kernel/mm/redhat_transparent_hugepage/defrag ]; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag; fi',
      unless   => 'if [ -f /sys/kernel/mm/redhat_transparent_hugepage/defrag ]; then grep -q "\[never\]" /sys/kernel/mm/redhat_transparent_hugepage/defrag; fi',
      provider => 'shell',
    } ->
    package { 'ntp': ensure => $ensure, }

    service { 'ntpd':
      ensure    => $enabled,
      enable    => $enabled,
      hasstatus => true,
      require   => Package['ntp'],
    }

    exec { 'ntp_sync':
      command     => 'ntpdate -u pool.ntp.org',
      refreshonly => true,
      subscribe   => Service['ntpd'],
    }
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
    class { 'puppet_cdh::java::repo': stage => 'first', } ->
    class { 'puppet_cdh::java::init': stage => 'first', }
  }

  if $install_jce {
    class { 'puppet_cdh::java::jce':
      ensure  => $ensure,
      require => Class['puppet_cdh::java::init'],
    }
  }

  if $cdh_version =~ /^5/ {
    include puppet_cdh::cdh::repo
    include puppet_cdh::cdh::init
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
    fail('Parameter $cdh_version must start with 5.')
  }
}
