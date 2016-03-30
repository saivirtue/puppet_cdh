# == Class cdh::hadoop::defaults
# Default parameters for cdh::hadoop configuration.
#
class puppet_cdh::cdh5::hadoop::defaults {
    $cluster_name                                = 'cdh'
    $journalnode_hosts                           = undef
    $dfs_journalnode_edits_dir                   = undef

    $datanode_mounts                             = undef
    $dfs_data_path                               = 'hdfs/dn'

    # $resourcemanager_hosts is not set here, because it defaults to the user
    # provided value of $namenode_hosts in hadoop.pp.
    $zookeeper_hosts                             = undef

    $yarn_local_path                             = 'yarn/local'
    $yarn_logs_path                              = 'yarn/logs'
    $dfs_block_size                              = 67108864 # 64MB default
    $enable_jmxremote                            = true
    $webhdfs_enabled                             = false
    $httpfs_enabled                              = true
    $mapreduce_system_dir                        = undef
    $io_file_buffer_size                         = undef

    $mapreduce_map_tasks_maximum                 = undef
    $mapreduce_reduce_tasks_maximum              = undef
    $mapreduce_job_reuse_jvm_num_tasks           = undef
    $mapreduce_reduce_shuffle_parallelcopies     = undef

    $mapreduce_map_memory_mb                     = undef
    $mapreduce_reduce_memory_mb                  = undef
    $mapreduce_task_io_sort_mb                   = undef
    $mapreduce_task_io_sort_factor               = undef
    $mapreduce_map_java_opts                     = undef
    $mapreduce_reduce_java_opts                  = undef
    $yarn_app_mapreduce_am_resource_mb           = undef
    $yarn_app_mapreduce_am_command_opts          = undef
    $yarn_app_mapreduce_am_job_client_port_range = undef

    $mapreduce_shuffle_port                      = undef
    $mapreduce_intermediate_compression          = false
    $mapreduce_intermediate_compression_codec    = 'org.apache.hadoop.io.compress.DefaultCodec'
    $mapreduce_output_compression                = false
    $mapreduce_output_compression_codec          = 'org.apache.hadoop.io.compress.DefaultCodec'
    $mapreduce_output_compression_type           = 'RECORD'

    $yarn_nodemanager_resource_memory_mb         = undef
    # Note:  Apparently puppet interprets a literal 1 as a String when it is on
    # its own.  Adding 0 to it converts it to a Fixnum, which will avoid a
    # 'comparison of String with X faild 'puppet failure.
    $yarn_nodemanager_resource_cpu_vcores        = max($::processorcount - 1, 1 + 0)
    $yarn_scheduler_minimum_allocation_mb        = undef
    $yarn_scheduler_maximum_allocation_mb        = undef
    $yarn_scheduler_minimum_allocation_vcores    = undef
    $yarn_scheduler_maximum_allocation_vcores    = undef

    $fair_scheduler_template                     = 'puppet_cdh/hadoop/fair-scheduler.xml.erb'
    $yarn_site_extra_properties                  = undef

    $hadoop_heapsize                             = undef
    $hadoop_namenode_opts                        = undef
    $yarn_heapsize                               = undef
    $dfs_datanode_hdfs_blocks_metadata_enabled   = undef

    $ganglia_hosts                               = undef
    $net_topology_script_template                = undef
    $gelf_logging_enabled                        = false
    $gelf_logging_host                           = 'localhost'
    $gelf_logging_port                           = 12201

    # JMX Ports (These are not currently configurable)
    $namenode_jmxremote_port                     = 9980
    $datanode_jmxremote_port                     = 9981
    $resourcemanager_jmxremote_port              = 9983
    $nodemanager_jmxremote_port                  = 9984
    $proxyserver_jmxremote_port                  = 9985
}
