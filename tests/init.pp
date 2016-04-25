Exec {
  path => ['/usr/bin:/usr/sbin:/bin:/sbin:'],
}

node 'puppetmaster' {

  #install CDH packages
  class{ 'puppet_cdh::params':
    #top scope
    ensure           => 'present',
    cdh_version      => '5',
    #hadoop scope
    cluster_name               => 'mycluster',
    namenode_hosts             => ['puppetmaster'],
    datanode_hosts             => ['puppetmaster'],
    secondary_host             => 'puppetmaster',
    dfs_name_dir               => '/dfs/nn',
    datanode_mounts            => '/dfs/dn',
    #yarn scope
    resourcemanager_hosts                    => ['puppetmaster'],
    nodemanager_hosts                        => ['puppetmaster'],
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
    #hbase scope
    hbase_master_host        => 'puppetmaster',
    regionserver_hosts       => ['puppetmaster'],
    #zookeeper scope
    zookeeper_hosts_hash => {'puppetmaster' => '1'}, #must specify with : hostname => zid
  }
  class { 'puppet_cdh':  
  }
}