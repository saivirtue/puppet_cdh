# == Class: cloudera::params
#
# the interface of all parameters usage
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
# === Authors:
#
# Sam Cho <sam@is-land.com.tw>
#
class puppet_cdh::params ( #parameters usage
  #global part#
  $ensure = 'present',
  $autoupgrade = false,
  $service_enable = true,
  $cdh_version = '5',
  $cdh_reposerver = undef,
  $cdh_repopath = undef,
  $install_lzo = false,
  $install_java = false,
  $install_jce = false,
  #hadoop part#
  $cluster_name = undef,
  $namenode_hosts = undef,
  $datanode_hosts = undef,
  $secondary_host = undef,
  $dfs_name_dir = undef,
  $datanode_mounts = undef,
  #yarn part#
  $resourcemanager_hosts = undef,
  $nodemanager_hosts = undef,
  $yarn_nodemanager_resource_memory_mb = undef,
  $yarn_nodemanager_resource_cpu_vcores = undef,
  $yarn_scheduler_minimum_allocation_mb = undef,
  $yarn_scheduler_maximum_allocation_mb = undef,
  $yarn_scheduler_minimum_allocation_vcores = undef,
  $yarn_scheduler_maximum_allocation_vcores = undef,
  $yarn_app_mapreduce_am_resource_mb = undef,
  $yarn_app_mapreduce_am_command_opts = undef,
  $mapreduce_map_java_opts = undef,
  $mapreduce_reduce_java_opts = undef,
  $mapreduce_map_memory_mb = undef,
  $mapreduce_reduce_memory_mb = undef,
  #hbase part#
  $hbase_master_host = undef,
  $regionserver_hosts = undef,
  #zookeeper part#
  $zookeeper_hosts_hash,
) {
  
  case $ensure {
    /(present)/ : { $enabled = true $dir_enabled = 'directory' }
    /(absent)/  : { $enabled = false $dir_enabled = 'absent' }
    default     : { fail('ensure parameter must be present or absent') }
  }
  
  if $::operatingsystemmajrelease { # facter 1.7+
    $majdistrelease = $::operatingsystemmajrelease
  } elsif $::lsbmajdistrelease {    # requires LSB to already be installed
    $majdistrelease = $::lsbmajdistrelease
  } elsif $::os_maj_version {       # requires stahnma/epel
    $majdistrelease = $::os_maj_version
  } else {
    $majdistrelease = regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1')
  }
}
