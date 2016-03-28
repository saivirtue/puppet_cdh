# == Class: puppet_cdh::cdh5::repo
#
# This class handles installing the Cloudera CDH software repositories.
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
# Djuri Baars <dsbaars@gmail.com>
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class puppet_cdh::cdh5::repo (
  $ensure         = $puppet_cdh::params::ensure,
  $reposerver     = $puppet_cdh::params::cdh_reposerver,
  $repopath       = $puppet_cdh::params::cdh5_repopath,
  $version        = $puppet_cdh::params::cdh_version,
  $aptkey         = $puppet_cdh::params::cdh_aptkey,
  $proxy          = $puppet_cdh::params::proxy,
  $proxy_username = $puppet_cdh::params::proxy_username,
  $proxy_password = $puppet_cdh::params::proxy_password
) inherits puppet_cdh::params {
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
      yumrepo { 'cloudera-cdh5':
        descr          => 'Cloudera\'s Distribution for Hadoop, Version 5',
        enabled        => $enabled,
        gpgcheck       => 1,
        gpgkey         => "${reposerver}${repopath}RPM-GPG-KEY-cloudera",
        baseurl        => "${reposerver}${repopath}${version}/",
        priority       => $puppet_cdh::params::yum_priority,
        protect        => $puppet_cdh::params::yum_protect,
        proxy          => $proxy,
        proxy_username => $proxy_username,
        proxy_password => $proxy_password,
      }

      file { '/etc/yum.repos.d/cloudera-cdh5.repo':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Yumrepo['cloudera-cdh5'],
      }

      Yumrepo['cloudera-cdh5'] -> Package<|tag == 'cloudera-cdh5'|>
    }
    'SLES': {
      zypprepo { 'cloudera-cdh5':
        descr       => 'Cloudera\'s Distribution for Hadoop, Version 5',
        enabled     => $enabled,
        gpgcheck    => 1,
        gpgkey      => "${reposerver}${repopath}RPM-GPG-KEY-cloudera",
        baseurl     => "${reposerver}${repopath}${version}/",
        autorefresh => 1,
        priority    => $puppet_cdh::params::yum_priority,
      }

      file { '/etc/zypp/repos.d/cloudera-cdh5.repo':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }

      Zypprepo['cloudera-cdh5'] -> Package<|tag == 'cloudera-cdh5'|>
    }
    'Debian', 'Ubuntu': {
      include '::apt'

      if ($::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '14.04') {
          apt::source { 'cloudera-cdh5':
              location     => "${reposerver}${repopath}",
              release      => "${::lsbdistcodename}-cdh${version}",
              repos        => 'contrib',
              key          => $aptkey,
              key_source   => "${reposerver}${repopath}archive.key",
              architecture => $puppet_cdh::params::architecture,
              pin          => '501'
          }
      } else {
          apt::source { 'cloudera-cdh5':
              location     => "${reposerver}${repopath}",
              release      => "${::lsbdistcodename}-cdh${version}",
              repos        => 'contrib',
              key          => $aptkey,
              key_source   => "${reposerver}${repopath}archive.key",
              architecture => $puppet_cdh::params::architecture,
          }
      }

      Apt::Source['cloudera-cdh5'] -> Package<|tag == 'cloudera-cdh5'|>
    }
    default: { }
  }
}
