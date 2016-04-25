hiera_include('classes')

Exec {
  path => ['/usr/bin:/usr/sbin:/bin:/sbin:'],
}
node 'puppetmaster' {
  include puppet_cdh
}
