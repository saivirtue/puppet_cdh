# == Class: puppet_cdh:cdh::hadoop::init
#
# This class handles installing Hadoop.
#
# === Parameters:
#
# === Actions:
#
# === Requires:
#
# Nothing.
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
class puppet_cdh::cdh::hadoop::init inherits puppet_cdh::cdh::hadoop::params {
  # If $dfs_name_dir is a list, this will be the
  # first entry in the list.  Else just $dfs_name_dir.
  # This used in a couple of execs throughout this module.
  $dfs_name_dir_main = inline_template('<%= (@dfs_name_dir.class == Array) ? @dfs_name_dir[0] : @dfs_name_dir %>')

  # Config files are installed into a directory
  # based on the value of $cluster_name.
  $config_directory = "/etc/hadoop/conf.${cluster_name}"

  # Set a boolean used to indicate that HA NameNodes
  # are intended to be used for this cluster.  HA NameNodes
  # require the JournalNodes are configured.
  $ha_enabled = $journalnode_hosts ? {
    undef   => false,
    default => true,
  }
  # If $ha_enabled is true, use $cluster_name as $nameservice_id.
  $nameservice_id = $ha_enabled ? {
    true    => $cluster_name,
    default => undef,
  }
  # Assume the primary namenode is the first entry in $namenode_hosts,
  # Set a variable here for reference in other classes.
  $primary_namenode_host = $namenode_hosts[0]
  # This is the primary NameNode ID used to identify
  # a NameNode when running HDFS with a logical nameservice_id.
  # We can't use '.' characters because NameNode IDs
  # will be used in the names of some Java properties,
  # which are '.' delimited.
  $primary_namenode_id = inline_template('<%= @primary_namenode_host.tr(\'.\', \'-\') %>')

  # Set a boolean used to indicate that HA YARN
  # is intended to be used for this cluster.  HA YARN
  # require the zookeeper is configured, and that
  # multiple ResourceManagers are specificed.
  #  if $ha_enabled and size($resourcemanager_hosts) > 1 and $zookeeper_hosts {
  #    $yarn_ha_enabled = true
  #    $yarn_cluster_id = $cluster_name
  #  } else {
  #    $yarn_ha_enabled = false
  #    $yarn_cluster_id = undef
  #  }

  # Assume the primary resourcemanager is the first entry in $resourcemanager_hosts
  # Set a variable here for reference in other classes.
  $primary_resourcemanager_host = $resourcemanager_hosts[0]

  if !$enabled {
    # this will ensure any unused files and folders being removed. (need to move other place?)
    $remove_dirs = ["/var/lib/hadoop*", "/var/log/hadoop*"]

    puppet_cdh::os::directory { $remove_dirs: ensure => $ensure }
  }

#  package { 'hadoop-client':
#    ensure   => $package_ensure, # for remove dependency packages, use 'purged' (use this careful!)
#    provider => 'yum',
#  }

  if $enabled {
    exec { 'package hadoop-client install':
      command => 'yum -qy install hadoop-client',
      unless  => 'rpm -qa | grep hadoop-client >/dev/null 2>&1',
    }
  } else {
    exec { 'package hadoop-client remove':
      command => 'yum -qy remove hadoop-client',
      onlyif  => 'rpm -qa | grep hadoop-client >/dev/null 2>&1',
    }
  }

  # Some Hadoop jobs need Zookeeper libraries, but for some reason they
  # are not installed via package dependencies.  Install the CDH
  # zookeeper package here explicitly.  This avoids
  # java.lang.NoClassDefFoundError: org/apache/zookeeper/KeeperException
  # errors.
  #    package { 'zookeeper':
  #        ensure => 'installed'
  #    }

  # Create the $cluster_name based $config_directory.
  file { ['/etc/hadoop/', $config_directory]:
    ensure => $dir_enabled,
    force  => true,
  }

  puppet_cdh::cdh::alternative { 'hadoop-conf':
    link    => '/etc/hadoop/conf',
    path    => $config_directory,
    enabled => $enabled,
  }

  if $enabled {
    # Render net-topology.sh from $net_topology_script_template
    # if it was given.
    $net_topology_script_ensure = $net_topology_script_template ? {
      undef   => 'absent',
      default => 'present',
    }
    $net_topology_script_path = "${config_directory}/net-topology.sh"

    file { $net_topology_script_path:
      ensure => $net_topology_script_ensure,
      mode   => '0755',
    }

    # Conditionally overriding content attribute since
    # $net_topology_script_template is default undef.
    if ($net_topology_script_ensure == 'present') {
      File[$net_topology_script_path] {
        content => template($net_topology_script_template), }
    }

    $fair_scheduler_enabled = $fair_scheduler_template ? {
      undef   => false,
      false   => false,
      default => true,
    }

    $fair_scheduler_allocation_file_ensure = $fair_scheduler_enabled ? {
      true    => 'present',
      false   => 'absent',
      default => 'absent',
    }

    # FairScheduler can be enabled
    # and this file will be used to configure
    # FairScheduler queues.
    file { "${config_directory}/fair-scheduler.xml":
      ensure  => $fair_scheduler_allocation_file_ensure,
      content => template($fair_scheduler_template),
    }

    file { "${config_directory}/log4j.properties": content => template('puppet_cdh/hadoop/log4j.properties.erb'), }

    file { "${config_directory}/core-site.xml": content => template('puppet_cdh/hadoop/core-site.xml.erb'), }

    file { "${config_directory}/hdfs-site.xml": content => template('puppet_cdh/hadoop/hdfs-site.xml.erb'), }

    file { "${config_directory}/hadoop-env.sh": content => template('puppet_cdh/hadoop/hadoop-env.sh.erb'), }

    file { "${config_directory}/mapred-site.xml": content => template('puppet_cdh/hadoop/mapred-site.xml.erb'), }

    file { "${config_directory}/yarn-site.xml": content => template('puppet_cdh/hadoop/yarn-site.xml.erb'), }

    file { "${config_directory}/yarn-env.sh": content => template('puppet_cdh/hadoop/yarn-env.sh.erb'), }

    file { "${config_directory}/container-executor.cfg": content => template('puppet_cdh/hadoop/container-executor.cfg.erb'), }

    # Render hadoop-metrics2.properties
    # if we have Ganglia Hosts to send metrics to.
    $hadoop_metrics2_ensure = $ganglia_hosts ? {
      undef   => 'absent',
      default => 'present',
    }

    file { "${config_directory}/hadoop-metrics2.properties":
      ensure  => $hadoop_metrics2_ensure,
      content => template('puppet_cdh/hadoop/hadoop-metrics2.properties.erb'),
    }
    # make nproc limits file
    $service_name = 'hdfs'

    file { "/etc/security/limits.d/hdfs.conf": content => template('puppet_cdh/os/ulimits.conf.erb'), }
  }

  # If the current node is meant to be JournalNode,
  # include the journalnode class.  JournalNodes can
  # be started at any time.
  if ($journalnode_hosts and (($::fqdn and $::fqdn in $journalnode_hosts) or ($::ipaddress and $::ipaddress in $journalnode_hosts) 
  or ($::ipaddress_eth1 and $::ipaddress_eth1 in $journalnode_hosts))) {
    include puppet_cdh::cdh::hadoop::journalnode
  }
}
