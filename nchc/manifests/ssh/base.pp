#/etc/puppet/modules/nchc/manifests/ssh/ssh.pp

class nchc::ssh::base{
    include nchc::params::ssh

    file { "/home/${nchc::params::ssh::user}/.ssh/":
        owner => "${nchc::params::ssh::user}",
        group => "${nchc::params::ssh::group}",
        ensure => "directory",
        alias => "${nchc::params::ssh::user}-ssh-dir",
    }
}

    
