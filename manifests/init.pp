#
# hudson module
#
# Copyright 2010, Atizo AG
# Simon Josi simon.josi+puppet(at)atizo.com
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

class hudson(
  $home = '/var/lib/hudson',
  $java_cmd = '',
  $user = 'hudson',
  $java_options = '-Djava.awt.headless=true',
  $port = '8080',
  $debug_level = 5,
  $enable_access_log = 'no',
  $handler_max = 100,
  $handler_idle = 20,
  $extra_arguments = '',
  $git_support = false
) {
  yum::repo{'hudson':
    descr => 'Hudson',
    baseurl => 'http://pkg.jenkins-ci.org/redhat',
    enabled => 1,
    gpgcheck => 0,
  }
  package{'hudson':
    ensure => present,
    require => Yum::Repo['hudson'],
  }
  service{'hudson':
    ensure => running,
    enable => true,
    hasstatus => true,
    require => [
      Package['hudson'],
      File['/etc/sysconfig/hudson'],
    ],
  }
  file{'/etc/sysconfig/hudson':
    content => template('hudson/sysconfig.erb'),
    require => Package['hudson'],
    notify => Service['hudson'],
    owner => root, group => root, mode => 0444;
  }
  if $git_support {
    include hudson::git
  }
}
