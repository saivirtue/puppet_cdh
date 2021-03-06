# === Class: puppet_cdh::cdh::params
#
# The class for initial CDh main parameters. <br/>
#
# === Authors:
#
# Sam Cho <sam@is-land.com.tw> <br/>
#
# === Copyright:
#
# Free Usage <br/>
class puppet_cdh::java::params inherits puppet_cdh::params {
  
  $package_name = 'oracle-j2sdk1.7'
  
  $java_reposerver = $::cloudera_java_reposerver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_java_reposerver,
  }
  
  $java_repopath = "/cm5/redhat/${majdistrelease}/${::architecture}/cm/"
  $cm_version = '5'
  $yum_priority = '50'
  $yum_protect = '0'
}
