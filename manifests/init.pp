# == Class: puppet_cdh
#
# The main class for installing CM and CDH
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*service_enable*]
#   Start service at boot.
#   Default: true
#
# [*cdh_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.puppet_cdh.com
#
# [*cdh_repopath*]
#   The path to add to the $cdh_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cdh_version*]
#   The version of Cloudera's Distribution, including Apache Hadoop to install.
#   Default: 5
#
# [*cm_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.puppet_cdh.com
#
# [*cm_repopath*]
#   The path to add to the $cm_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cm_version*]
#   The version of Cloudera Manager to install.
#   Default: 5
#
# [*cm5_repopath*]
#   The path to add to the $cm_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*ci_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.puppet_cdh.com
#
# [*ci_repopath*]
#   The path to add to the $ci_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*ci_version*]
#   The version of Cloudera Impala to install.
#   Default: 1
#
# [*cs_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.puppet_cdh.com
#
# [*cs_repopath*]
#   The path to add to the $cs_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cs_version*]
#   The version of Cloudera Search to install.
#   Default: 1
#
# [*cg_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.puppet_cdh.com
#
# [*cg_repopath*]
#   The path to add to the $cg_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cg_version*]
#   The version of Cloudera Search to install.
#   Default: 5
#
# [*cm_server_host*]
#   Hostname of the Cloudera Manager server.
#   Default: localhost
#
# [*cm_server_port*]
#   Port to which the Cloudera Manager server is listening.
#   Default: 7182
#
# [*use_tls*]
#   Whether to enable TLS on the Cloudera Manager server and agent.
#   Default: false
#
# [*verify_cert_file*]
#   The file holding the public key of the Cloudera Manager server as well as
#   the chain of signing certificate authorities. PEM format.
#   Default: /etc/pki/tls/certs/puppet_cdh_manager.crt or
#            /etc/ssl/certs/puppet_cdh_manager.crt
#
# [*use_parcels*]
#   Whether to install CDH software via parcels or packages.
#   Default: true
#
# [*install_lzo*]
#   Whether to install the native LZO compression library packages.  If
#   *use_parcels* is false, then also install the Hadoop-specific LZO
#   compression library packages.  You must configure and deploy the GPLextras
#   parcel repository if *use_parcels* is true.
#   Default: false
#
# [*install_java*]
#   Whether to install the Cloudera supplied Oracle Java Development Kit.  If
#   this is set to false, then an Oracle JDK will have to be installed prior to
#   applying this module.
#   Default: true
#
# [*install_jce*]
#   Whether to install the Oracle Java Cryptography Extension unlimited
#   strength jurisdiction policy files.  This requires manual download of the
#   zip file.  See files/README_JCE.md for download instructions.
#   Default: false
#
# [*install_cmserver*]
#   Whether to install the Cloudera Manager Server.  This should only be set to
#   true on one host in your environment.
#   Default: false
#
# [*database_name*]
#   Name of the database to use for Cloudera Manager.
#   Default: scm
#
# [*username*]
#   Name of the user to use to connect to *database_name*.
#   Default: scm
#
# [*password*]
#   Password to use to connect to *database_name*.
#   Default: scm
#
# [*db_host*]
#   Host to connect to for *database_name*.
#   Default: localhost
#
# [*db_port*]
#   Port on *db_host* to connect to for *database_name*.
#   Default: 3306
#
# [*db_user*]
#   Administrative database user on *db_host*.
#   Default: root
#
# [*db_pass*]
#   Administrative database user *db_user* password.
#   Default:
#
# [*db_type*]
#   Which type of database to use for Cloudera Manager.  Valid options are
#   embedded, mysql, oracle, or postgresql.
#   Default: embedded
#
# [*server_ca_file*]
#   The file holding the PEM public key of the Cloudera Manager server
#   certificate authority.
#   Default: /etc/pki/tls/certs/puppet_cdh_manager-ca.crt or
#            /etc/ssl/certs/puppet_cdh_manager-ca.crt
#
# [*server_cert_file*]
#   The file holding the PEM public key of the Cloudera Manager server.
#   Default: /etc/pki/tls/certs/${::fqdn}-puppet_cdh_manager.crt or
#            /etc/ssl/certs/${::fqdn}-puppet_cdh_manager.crt
#
# [*server_key_file*]
#   The file holding the PEM private key of the Cloudera Manager server.
#   Default: /etc/pki/tls/private/${::fqdn}-puppet_cdh_manager.key or
#            /etc/ssl/private/${::fqdn}-puppet_cdh_manager.key
#
# [*server_chain_file*]
#   The file holding the PEM public key(s) of the Cloudera Manager server
#   intermediary certificate authority.
#   Default: none
#
# [*server_keypw*]
#   The password used to protect the keystore.
#   Default: none
#
# [*proxy*]
#   The URL to the proxy server for the YUM repositories.
#   Default: absent
#
# [*proxy_username*]
#   The username for the YUM proxy.
#   Default: absent
#
# [*proxy_password*]
#   The password for the YUM proxy.
#   Default: absent
#
# [*parcel_dir*]
#   The directory where parcels are downloaded and distributed.
#   Default: /opt/puppet_cdh/parcels
#
# === Actions:
#
# Installs YUM repository configuration files.
# Tunes the kernel parameter vm.swappiness to be 0.
#
# === Requires:
#
# Package['jdk'] which is provided by Class['puppet_cdh::java'].  If parameter
# "$install_java => false", then an external Puppet module will have to install
# the Sun/Oracle JDK and provide a Package['jdk'] resource.
#
# === Sample Usage:
#
#   class { 'puppet_cdh':
#     cdh_version    => '4.1',
#     cm_version     => '4.1',
#     cm_server_host => 'smhost.example.com',
#   }
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw>
#
# === Copyright:
#
# Free Usage
#
class puppet_cdh ( #parameters usage
  $ensure            = $puppet_cdh::params::ensure,
  $autoupgrade       = $puppet_cdh::params::safe_autoupgrade,
  $service_ensure    = $puppet_cdh::params::service_ensure,
  $service_enable    = $puppet_cdh::params::safe_service_enable,
  $cdh_reposerver    = $puppet_cdh::params::cdh_reposerver,
  $cdh_repopath      = $puppet_cdh::params::cdh_repopath,
  $cdh_version       = $puppet_cdh::params::cdh_version,
  $cdh5_repopath     = $puppet_cdh::params::cdh5_repopath,
  $cm_reposerver     = $puppet_cdh::params::cm_reposerver,
  $cm_repopath       = $puppet_cdh::params::cm_repopath,
  $cm_version        = $puppet_cdh::params::cm_version,
  $cm5_repopath      = $puppet_cdh::params::cm5_repopath,
  $ci_reposerver     = $puppet_cdh::params::ci_reposerver,
  $ci_repopath       = $puppet_cdh::params::ci_repopath,
  $ci_version        = $puppet_cdh::params::ci_version,
  $cs_reposerver     = $puppet_cdh::params::cs_reposerver,
  $cs_repopath       = $puppet_cdh::params::cs_repopath,
  $cs_version        = $puppet_cdh::params::cs_version,
  $cg_reposerver     = $puppet_cdh::params::cg_reposerver,
  $cg_repopath       = $puppet_cdh::params::cg_repopath,
  $cg_version        = $puppet_cdh::params::cg_version,
  $cg5_repopath      = $puppet_cdh::params::cg5_repopath,
  $cm_server_host    = $puppet_cdh::params::cm_server_host,
  $cm_server_port    = $puppet_cdh::params::cm_server_port,
  $use_tls           = $puppet_cdh::params::safe_cm_use_tls,
  $verify_cert_file  = $puppet_cdh::params::verify_cert_file,
  $use_parcels       = $puppet_cdh::params::safe_use_parcels,
  $install_lzo       = $puppet_cdh::params::safe_install_lzo,
  $install_java      = $puppet_cdh::params::safe_install_java,
  $install_jce       = $puppet_cdh::params::safe_install_jce,
  $install_cmserver  = $puppet_cdh::params::safe_install_cmserver,
  $database_name     = $puppet_cdh::params::database_name,
  $username          = $puppet_cdh::params::username,
  $password          = $puppet_cdh::params::password,
  $db_host           = $puppet_cdh::params::db_host,
  $db_port           = $puppet_cdh::params::db_port,
  $db_user           = $puppet_cdh::params::db_user,
  $db_pass           = $puppet_cdh::params::db_pass,
  $db_type           = $puppet_cdh::params::db_type,
  $server_ca_file    = $puppet_cdh::params::server_ca_file,
  $server_cert_file  = $puppet_cdh::params::server_cert_file,
  $server_key_file   = $puppet_cdh::params::server_key_file,
  $server_chain_file = $puppet_cdh::params::server_chain_file,
  $server_keypw      = $puppet_cdh::params::server_keypw,
  $proxy             = $puppet_cdh::params::proxy,
  $proxy_username    = $puppet_cdh::params::proxy_username,
  $proxy_password    = $puppet_cdh::params::proxy_password,
  $parcel_dir        = $puppet_cdh::params::parcel_dir
  ) inherits puppet_cdh::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($use_tls)
  validate_bool($use_parcels)
  validate_bool($install_lzo)
  validate_bool($install_java)
  validate_bool($install_jce)
  validate_bool($install_cmserver)

  exec { 'set_vm_swappiness':
    command  => 'sysctl -w vm.swappiness=0',
    unless   => 'test 0 -eq `sysctl -n vm.swappiness`',
    path     => '/sbin',
    provider => 'shell',
  }

  exec { 'disable_transparent_hugepage_defrag':
    command  => 'if [ -f /sys/kernel/mm/transparent_hugepage/defrag ]; then echo never > /sys/kernel/mm/transparent_hugepage/defrag; fi',
    unless   => 'if [ -f /sys/kernel/mm/transparent_hugepage/defrag ]; then grep -q "\[never\]" /sys/kernel/mm/transparent_hugepage/defrag; fi',
    path     => '/usr/bin:/usr/sbin:/bin:/sbin',
    provider => 'shell',
  }

  exec { 'disable_redhat_transparent_hugepage_defrag':
    command  => 'if [ -f /sys/kernel/mm/redhat_transparent_hugepage/defrag ]; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag; fi',
    unless   => 'if [ -f /sys/kernel/mm/redhat_transparent_hugepage/defrag ]; then grep -q "\[never\]" /sys/kernel/mm/redhat_transparent_hugepage/defrag; fi',
    path     => '/usr/bin:/usr/sbin:/bin:/sbin',
    provider => 'shell',
  }

  # Configuring Dependencies Before Install Cluster
  package { 'ntp':
    ensure => 'present',
  }
  service { 'ntpd':
    ensure    => 'running',
    enable    => true,
    hasstatus => true,
    require   => Package['ntp'],
  }
  exec { 'ntp_sync':
    command => 'ntpdate -u pool.ntp.org',
    path    => '/usr/sbin',
    require => Service['ntpd'],
  }
  exec {'selinux_check':
    command => 'fail("selinux should be disabled")',
    path    => '/usr/sbin',
    unless  => '[ /usr/sbin/getenforce != "Disabled" ]',
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
    Class['puppet_cdh::java::repo'] -> Class['puppet_cdh::java::java']
    class { 'puppet_cdh::java::java':
      ensure      => $ensure,
      autoupgrade => $autoupgrade,
    }
  }

  if $install_jce {
    class { 'puppet_cdh::java::jce':
      ensure  => $ensure,
      require => Class['puppet_cdh::java::java'],
    }
  }

  # Installing the CDH RPMs if we are going to use parcels.
  if $use_parcels {
    if $cdh_version =~ /^5/ {
      class { 'puppet_cdh::cdh::repo':
        ensure         => $ensure,
        reposerver     => $cdh_reposerver,
        repopath       => $cdh5_repopath,
        version        => $cdh_version,
      }
      contain 'puppet_cdh::cdh5::repo'

      class { 'puppet_cdh::cdh::cdh':
        ensure         => $ensure,
        autoupgrade    => $autoupgrade,
        service_ensure => $service_ensure,
      }
      Class['puppet_cdh::cdh::repo'] -> Class['puppet_cdh::cdh::cdh']
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
    }
  } else {
    fail('Parameter $cdh_version must start with either 4 or 5.')
  }
}
