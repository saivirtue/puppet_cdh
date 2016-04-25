# == Class: puppet_cdh::cdh::alternative
#
# Runs update-alternatives command to create and set CDH related alternatives.
# This is usually used to name config directories after $cluster_name.
#
# == Parameters
#
# [*link*]
#   Symlink pointing to /etc/alternatives/$name.
#   Default: undef
#
# [*path*]
#   Location of one of the alternative target files.
#   Default: undef
#
# [*priority*]
#   integer; options with higher numbers have higher priority in automatic mode.
#   Default: 50
#
# === Authors:
# 
# Sam Cho <sam@is-land.com.tw>
#
define puppet_cdh::cdh::alternative ($link, $path, $priority = 50, $enabled) {
  # Update $title alternatives to point $link at $path
  if $enabled {
    exec { "install_alternatives_${title}":
      command => "update-alternatives --install ${link} ${name} ${path} ${priority} && update-alternatives --set ${name} ${path}",
      unless  => "update-alternatives --display ${name} | grep -q '${path}'",
      require => File[$path],
    }
  } else {
#    exec { "remove_alternatives_${title}":
#      command => "update-alternatives --remove ${name} ${path}",
#      onlyif  => "update-alternatives --display ${name} | grep -q '${path}'",
#      before  => File[$path],
#    }
  }
}
