# == Class: puppet-cdh::cdh5
#
# This class handles installing the Cloudera Distribution, including Apache
# Hadoop.
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
# === Actions:
#
# Installs Bigtop, Hadoop, Hue-plugins, HBase, Hive, Oozie, Pig, ZooKeeper,
# and Flume-NG.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'puppet-cdh::cdh5': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#  Copyright (c) 2011, Cloudera, Inc. All Rights Reserved.
#
#  Cloudera, Inc. licenses this file to you under the Apache License,
#  Version 2.0 (the "License"). You may not use this file except in
#  compliance with the License. You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  This software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#  CONDITIONS OF ANY KIND, either express or implied. See the License for
#  the specific language governing permissions and limitations under the
#  License.
#
class puppet-cdh::cdh5 (
  $ensure         = $puppet-cdh::params::ensure,
  $autoupgrade    = $puppet-cdh::params::safe_autoupgrade,
  $service_ensure = $puppet-cdh::params::service_ensure) inherits puppet-cdh::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  # anchor { 'puppet-cdh::cdh5::begin': }
  # anchor { 'puppet-cdh::cdh5::end': }

  #  Class {
  # require => Anchor['puppet-cdh::cdh5::begin'],
  # before  => Anchor['puppet-cdh::cdh5::end'],
  #  }
  #  class { 'puppet-cdh::cdh5::bigtop':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  class { 'puppet-cdh::cdh5::hadoop':
    #    ensure      => $ensure,
    #    autoupgrade => $autoupgrade,
    cluster_name               => 'mycluster',
    namenode_hosts             => ['puppet-cdh'],
    dfs_name_dir               => '/var/lib/hadoop/name',
    datanode_mounts            => '/dfs/dn',
    yarn_nodemanager_resource_memory_mb      => '6144',
    yarn_nodemanager_resource_cpu_vcores     => '4',
    yarn_scheduler_minimum_allocation_mb     => '512',
    yarn_scheduler_maximum_allocation_mb     => '3072',
    yarn_scheduler_minimum_allocation_vcores => '1',
    yarn_scheduler_maximum_allocation_vcores => '4',
    yarn_app_mapreduce_am_resource_mb        => '1024',
    yarn_app_mapreduce_am_command_opts       => '-Djava.net.preferIPv4Stack=true -Xmx858993459',
    mapreduce_map_java_opts    => '-Djava.net.preferIPv4Stack=true -Xmx429496730',
    mapreduce_reduce_java_opts => '-Djava.net.preferIPv4Stack=true -Xmx858993459',
    mapreduce_map_memory_mb    => '512',
    mapreduce_reduce_memory_mb => '1024',
  }

  class { 'puppet-cdh::cdh5::hadoop::master':
  }

  class { 'puppet-cdh::cdh5::hadoop::worker':
  }

  #  class { 'puppet-cdh::cdh5::hue':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::hue::plugins':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
    class { 'puppet-cdh::cdh5::hbase::master':
      cluster_name => 'mycluster',
      hostname     => 'puppet-cdh',
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
    }
    class { 'puppet-cdh::cdh5::hbase::regionserver':
      cluster_name => 'mycluster',
      hostname     => 'puppet-cdh',
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
    }
  #  class { 'puppet-cdh::cdh5::hive':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::oozie':
  #    ensure         => $ensure,
  #    autoupgrade    => $autoupgrade,
  #    service_ensure => $service_ensure,
  #  }
  #  class { 'puppet-cdh::cdh5::pig':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  class { 'puppet-cdh::cdh5::zookeeper':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  }
  #  class { 'puppet-cdh::cdh5::flume':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::impala':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::search':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::search::lilyhbase':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::crunch':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::hcatalog':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::llama':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::sqoop':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::sqoop2':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
  #  class { 'puppet-cdh::cdh5::spark':
  #    ensure      => $ensure,
  #    autoupgrade => $autoupgrade,
  #  }
}
