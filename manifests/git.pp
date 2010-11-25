class hudson::git {
  include git
  exec{'hudson_ssh_keypair':
    user => $hudson::user,
    command => "ssh-keygen -f ${hudson::home}/.ssh/id_rsa -t rsa -N ''",
    creates => "${hudson::home}/.ssh/id_rsa",
  }
  file{"${hudson::home}/.ssh/config":
    content => 'StrictHostKeyChecking no',
    owner => hudson, group => hudson, mode => 0444;
  }
}
