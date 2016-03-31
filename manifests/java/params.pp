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
class puppet_cdh::java::params {
  # Customize these values if you (for example) mirror public YUM repos to your
  # internal network.
  $yum_priority = '50'
  $yum_protect = '0'

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  
  $ensure = $::cloudera_ensure ? {
    undef => 'present',
    default => $::cloudera_ensure,
  }

  $java_reposerver = $::cloudera_java_reposerver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_java_reposerver,
  }

  $install_java = $::cloudera_install_java ? {
    undef => true,
    default => $::cloudera_install_java,
  }
  if is_string($install_java) {
    $safe_install_java = str2bool($install_java)
  } else {
    $safe_install_java = $install_java
  }

  $install_jce = $::cloudera_install_jce ? {
    undef => false,
    default => $::cloudera_install_jce,
  }
  if is_string($install_jce) {
    $safe_install_jce = str2bool($install_jce)
  } else {
    $safe_install_jce = $install_jce
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

  $cm_version  = '5'

  $database_name = 'scm'
  $username      = 'scm'
  $password      = 'scm'
  $db_host       = 'localhost'
  $db_port       = '3306'
  $db_user       = 'root'
  $db_pass       = ''
  $db_type       = 'embedded'

  case $::operatingsystem {
    'CentOS', 'RedHat', 'OEL', 'OracleLinux': {
      $java_package_name = 'oracle-j2sdk1.7'
      $java_repopath = "/cm5/redhat/${majdistrelease}/${::architecture}/cm/"
      $tls_dir = '/etc/pki/tls'
      $lzo_package_name = 'lzo'
    }
#    'SLES': {
#      $java_package_name = 'jdk'
#      #$package_provider = 'zypper'
#      $cdh_repopath = "/cdh4/sles/${majdistrelease}/${::architecture}/cdh/"
#      $cm_repopath = "/cm4/sles/${majdistrelease}/${::architecture}/cm/"
#      $ci_repopath = "/impala/sles/${majdistrelease}/${::architecture}/impala/"
#      $cs_repopath = "/search/sles/${majdistrelease}/${::architecture}/search/"
#      $cg_repopath = "/gplextras/sles/${majdistrelease}/${::architecture}/gplextras/"
#      $java5_package_name = 'oracle-j2sdk1.7'
#      $cm5_repopath = "/cm5/sles/${majdistrelease}/${::architecture}/cm/"
#      $cdh5_repopath = "/cdh5/sles/${majdistrelease}/${::architecture}/cdh/"
#      $cg5_repopath = "/gplextras5/sles/${majdistrelease}/${::architecture}/gplextras/"
#      $tls_dir = '/etc/ssl'
#      $lzo_package_name = 'liblzo2-2'
#    }
#    'Debian': {
#      $java_package_name = 'oracle-j2sdk1.6'
#      $cdh_repopath = "/cdh4/debian/${::lsbdistcodename}/${::architecture}/cdh/"
#      $cm_repopath = "/cm4/debian/${::lsbdistcodename}/${::architecture}/cm/"
#      $ci_repopath = "/impala/debian/${::lsbdistcodename}/${::architecture}/impala/"
#      $cs_repopath = "/search/debian/${::lsbdistcodename}/${::architecture}/search/"
#      $cg_repopath = "/gplextras/debian/${::lsbdistcodename}/${::architecture}/gplextras/"
#      $java5_package_name = 'oracle-j2sdk1.7'
#      $cm5_repopath = "/cm5/debian/${::lsbdistcodename}/${::architecture}/cm/"
#      $cdh5_repopath = "/cdh5/debian/${::lsbdistcodename}/${::architecture}/cdh/"
#      $cg5_repopath = "/gplextras5/debian/${::lsbdistcodename}/${::architecture}/gplextras/"
#      $cdh_aptkey = false
#      $cm_aptkey = '327574EE02A818DD'
#      $ci_aptkey = false
#      $cs_aptkey = false
#      $cg_aptkey = false
#      $architecture = undef
#      $tls_dir = '/etc/ssl'
#      $lzo_package_name = 'liblzo2-2'
#    }
#    'Ubuntu': {
#      $java_package_name = 'oracle-j2sdk1.6'
#      $cdh_repopath = "/cdh4/ubuntu/${::lsbdistcodename}/${::architecture}/cdh/"
#      $cm_repopath = "/cm4/ubuntu/${::lsbdistcodename}/${::architecture}/cm/"
#      $ci_repopath = "/impala/ubuntu/${::lsbdistcodename}/${::architecture}/impala/"
#      $cs_repopath = "/search/ubuntu/${::lsbdistcodename}/${::architecture}/search/"
#      $cg_repopath = "/gplextras/ubuntu/${::lsbdistcodename}/${::architecture}/gplextras/"
#      $java5_package_name = 'oracle-j2sdk1.7'
#      $cm5_repopath = "/cm5/ubuntu/${::lsbdistcodename}/${::architecture}/cm/"
#      $cdh5_repopath = "/cdh5/ubuntu/${::lsbdistcodename}/${::architecture}/cdh/"
#      $cg5_repopath = "/gplextras5/ubuntu/${::lsbdistcodename}/${::architecture}/gplextras/"
#      $cdh_aptkey = false
#      $cm_aptkey = '327574EE02A818DD'
#      $ci_aptkey = false
#      $cs_aptkey = false
#      $cg_aptkey = false
#      case $::lsbdistcodename {
#        'lucid': { $architecture = undef }
#        default: { $architecture = $::architecture }
#      }
#      $tls_dir = '/etc/ssl'
#      $lzo_package_name = 'liblzo2-2'
#    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
