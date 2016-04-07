# == Define cdh::alternative
# Runs update-alternatives command to create and set CDH related alternatives.
# This is usually used to name config directories after $cluster_name.
#
# == Parameters
# $link      - Symlink pointing to /etc/alternatives/$name.
# $path      - Location of one of the alternative target files.
# $priority  - integer; options with higher numbers have higher
#              priority in automatic mode.  Default: 50
#
# == Usage
#   cdh::alternative { 'hadoop-conf':
#       link    => '/etc/hadoop/conf',
#       path    => $config_directory,
#   }
#
define puppet_cdh::cdh::alternative ($link, $path, $priority = 50, $enabled) {
  # Update $title alternatives to point $link at $path
  if $enabled {
    exec { "install-alternatives_${title}":
      command => "update-alternatives --install ${link} ${name} ${path} ${priority} && update-alternatives --set ${name} ${path}",
      unless  => "update-alternatives --display ${name} | grep -q 'Value: ${path}'",
      path    => '/bin:/usr/bin:/usr/sbin',
      require => File[$path],
    }
    # Remove $title alternatives at $path
  } else {
    exec { "remove-alternatives_${title}":
      command => "update-alternatives --remove ${name} ${path}",
      onlyif  => "update-alternatives --display ${name} | grep -q 'Value: ${path}'",
      path    => '/bin:/usr/bin:/usr/sbin',
    }
  }
}
