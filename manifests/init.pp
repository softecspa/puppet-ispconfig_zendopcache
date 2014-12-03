# = Class: ispconfig_zendopcache
#
# This class install zend-opcache in ispconfig cluster node by including php5::zendopcache class with a path for the monitoring page.
#
# == Parameters:
#
# [*ensure*]
#   If present, enable zend opcache extension. Default: present
#
# [*version*]
#   Module version to install. If it's not specified, last version'll be installed.
#
# [*memory_consumption*]
#   The size of the shared memory storage used by OPcache, in megabytes. Default: 128
#
# [*interned_strings_buffer*]
#   The amount of memory used to store interned strings, in megabytes. Default: 8
#
# [*max_accelerated_files*]
#   The maximum number of keys (and therefore scripts) in the OPcache hash table. Default: 4000
#
# [*revalidate_freq*]
#  How often to check script timestamps for updates, in seconds. 0 will result in OPcache checking for updates on every request. Default: 60
#
# [*fast_shutdown*]
#  If 1, enable opcache.fast_shutdown directive. Default: 1
#
# [*enable_cli*]
#  Enables the opcode cache for the CLI version of PHP. Default: 1
#
# == Requires:
#   - class["php5::zendopcache"]
#
# == Sample Usage:
#
#   class {'ispconfig_zendopcache':
#     version    => '7.0.2',
#     enable_cli => '0',
#   }
#
#
class ispconfig_zendopcache (
  $cluster        = $cluster,
  $clusterdomain  = $clusterdomain,
  $clusterslaves  = $clusterslaves,
  ) {

  include softec_php::opcache

  file { "/var/www/cluster.${cluster}.${clusterdomain}/web/opcache.php":
    ensure  => present,
    content => template('ispconfig_zendopcache/opcache.php.erb'),
    owner   => 'root',
    group   => 'www-data',
    mode    => '0440'
  }

  file { "/var/www/cluster.${cluster}.${clusterdomain}/web/check-opcache.php":
    ensure  => present,
    owner   => 'root',
    group   => 'www-data',
    mode    => '0550'
  }

  file {'/var/www/sharedip/ocp.php':
    ensure  => present,
    source  => 'puppet:///modules/ispconfig_zendopcache/ocp.php',
    owner   => 'root',
    group   => 'www-data',
    mode    => '0440'
  }

}
