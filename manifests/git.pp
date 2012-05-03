class hudson::git {
  include git
  Class['hudson::git'] <- Class['hudson']
  file{"${hudson::home}/.ssh":
    ensure => directory,
    owner => hudson, group => hudson, mode => 0700;
  }
  exec{'hudson_ssh_keypair':
    user => $hudson::user,
    command => "ssh-keygen -f ${hudson::home}/.ssh/id_rsa -t rsa -N ''",
    require => File["${hudson::home}/.ssh"],
    creates => "${hudson::home}/.ssh/id_rsa",
  }
  file{"${hudson::home}/.ssh/config":
    content => 'StrictHostKeyChecking no',
    require => File["${hudson::home}/.ssh"],
    owner => hudson, group => hudson, mode => 0444;
  }
}
