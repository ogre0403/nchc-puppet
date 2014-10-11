#/etc/puppet/modules/nchc/manifests/ssh/ssh.pp


class nchc::ssh::client inherits nchc::ssh::base{

    if $nchc::params::ssh::auto_login == "true"{

        file { "/home/${nchc::params::ssh::user}/.ssh/id_rsa":
            ensure => present,
            owner => "${nchc::params::ssh::user}",
            group => "${nchc::params::ssh::group}",
            mode => "600",
            source => "puppet:///modules/nchc/ssh/id_rsa.pri",
            require => File["${nchc::params::ssh::user}-ssh-dir"],
        }
    }elsif $nchc::params::ssh::auto_login == "false"{
        file { "/home/${nchc::params::ssh::user}/.ssh/id_rsa":
            ensure => absent,
        } 
    }
}


