# == Class: puppet_cdh::java::repo
#
# This class handles installing the Java repositories.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*reposerver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*repopath*]
#   The path to add to the $reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*version*]
#   The version of Cloudera's Distribution, including Apache Hadoop to install.
#   Default: 5
#
# === Actions:
#
# Installs YUM repository configuration files.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'puppet_cdh::cdh5::repo':
#     version => '4.1',
#   }
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw> <br/>
#
# === Copyright:
#
# Free Usage
#
class puppet_cdh::java::repo inherits puppet_cdh::java::params {
  $reposerver = $puppet_cdh::java::params::java_reposerver
  $repopath   = $puppet_cdh::java::params::java_repopath
  $version    = $puppet_cdh::java::params::cm_version
   
  case $ensure {
    /(present)/: {
      $enabled = '1'
    }
    /(absent)/: {
      $enabled = '0'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::operatingsystem {
    'CentOS', 'RedHat', 'OEL', 'OracleLinux': {
      yumrepo { 'cloudera-manager':
        descr          => 'Cloudera Manager',
        enabled        => $enabled,
        gpgcheck       => 1,
        gpgkey         => "${reposerver}${repopath}RPM-GPG-KEY-cloudera",
        baseurl        => "${reposerver}${repopath}${version}/",
        priority       => $yum_priority,
        protect        => $yum_protect,
      }

      file { '/etc/yum.repos.d/cm_java.repo':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    }
#    'SLES': {
#      zypprepo { 'cloudera-manager':
#        descr       => 'Cloudera Manager',
#        enabled     => $enabled,
#        gpgcheck    => 1,
#        gpgkey      => "${reposerver}${repopath}RPM-GPG-KEY-cloudera",
#        baseurl     => "${reposerver}${repopath}${version}/",
#        priority    => $cloudera::params::yum_priority,
#        autorefresh => 1,
#        notify      => Exec['cloudera-import-gpgkey'],
#      }
#
#      file { '/etc/zypp/repos.d/cloudera-manager.repo':
#        ensure => 'file',
#        owner  => 'root',
#        group  => 'root',
#        mode   => '0644',
#      }
#
#      exec { 'cloudera-import-gpgkey':
#        path        => '/bin:/usr/bin:/sbin:/usr/sbin',
#        command     => "rpm --import ${reposerver}${repopath}RPM-GPG-KEY-cloudera",
#        refreshonly => true,
#      }
#
#      Zypprepo['cloudera-manager'] -> Package<|tag == 'cloudera-manager'|>
#    }
#    'Debian', 'Ubuntu': {
#      include '::apt'
#
#      apt::source { 'cloudera-manager':
#        location     => "${reposerver}${repopath}",
#        release      => "${::lsbdistcodename}-cm${version}",
#        repos        => 'contrib',
#        key          => $aptkey,
#        key_source   => "${reposerver}${repopath}archive.key",
#        architecture => $cloudera::params::architecture,
#      }
#
#      Apt::Source['cloudera-manager'] -> Package<|tag == 'cloudera-manager'|>
#    }
    default: { }
  }
}
