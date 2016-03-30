# == Class: cloudera::params
#
# the interface of all parameters usage
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw> <br/>
#
# === Copyright:
#
# Free Usage <br/>
#
class puppet_cdh::params {
  
  include puppet_cdh::cdh::params
  include puppet_cdh::cdh::hadoop::params
  include puppet_cdh::cdh::hbase::params
}
