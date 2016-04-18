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
class puppet_cdh::cdh::params inherits puppet_cdh::params {
  # Customize these values if you (for example) mirror public YUM repos to your
  # internal network.
  $yum_priority = '50'
  $yum_protect = '0'

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $cdh_reposerver = $::cloudera_cdh_reposerver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_cdh_reposerver,
  }

  $oozie_ext = $::cloudera_oozie_ext ? {
    undef   => 'http://archive.cloudera.com/gplextras/misc/ext-2.2.zip',
    default => $::cloudera_oozie_ext,
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.

  $cm_use_tls = $::cloudera_cm_use_tls ? {
    undef => false,
    default => $::cloudera_cm_use_tls,
  }
  if is_string($cm_use_tls) {
    $safe_cm_use_tls = str2bool($cm_use_tls)
  } else {
    $safe_cm_use_tls = $cm_use_tls
  }

  $use_package = $::cloudera_use_package ? {
    undef => true,
    default => $::cloudera_use_package,
  }
  if is_string($use_package) {
    $safe_use_package = str2bool($use_package)
  } else {
    $safe_use_package = $use_package
  }

  $install_lzo = $::cloudera_install_lzo ? {
    undef => false,
    default => $::cloudera_install_lzo,
  }
  if is_string($install_lzo) {
    $safe_install_lzo = str2bool($install_lzo)
  } else {
    $safe_install_lzo = $install_lzo
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

  $install_cmserver = $::cloudera_install_cmserver ? {
    undef => false,
    default => $::cloudera_install_cmserver,
  }
  if is_string($install_cmserver) {
    $safe_install_cmserver = str2bool($install_cmserver)
  } else {
    $safe_install_cmserver = $install_cmserver
  }

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
#      $java_package_name = 'jdk'
#      $cdh_repopath = "/cdh4/redhat/${majdistrelease}/${::architecture}/cdh/"
#      $cm_repopath = "/cm4/redhat/${majdistrelease}/${::architecture}/cm/"
#      $cs_repopath = "/search/redhat/${majdistrelease}/${::architecture}/search/"
#      $cg_repopath = "/gplextras/redhat/${majdistrelease}/${::architecture}/gplextras/"
#      $cm5_repopath = "/cm5/redhat/${majdistrelease}/${::architecture}/cm/"
      $cdh_repopath = "/cdh5/redhat/${majdistrelease}/${::architecture}/cdh/"
#      $cg5_repopath = "/gplextras5/redhat/${majdistrelease}/${::architecture}/gplextras/"
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

  $parcel_dir = $::cloudera_parcel_dir ? {
    undef => '/opt/cloudera/parcels',
    default => $::cloudera_parcel_dir,
  }

}
