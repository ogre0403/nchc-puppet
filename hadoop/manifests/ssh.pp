#/etc/puppet/modules/hadoop/manifests/ssh.pp

class hadoop::ssh{
    include hadoop::params
    file { "/home/${hadoop::params::hdadm}/.ssh/":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        ensure => "directory",
        alias => "${hadoop::params::hdadm}-ssh-dir",
    }
}

class hadoop::ssh::client inherits hadoop::ssh{

    if $hadoop::params::disable_auto_ssh == "false"{

        file { "/home/${hadoop::params::hdadm}/.ssh/id_rsa":
            ensure => present,
            owner => "${hadoop::params::hdadm}",
            group => "${hadoop::params::hdgrp}",
            mode => "600",
            source => "puppet:///modules/hadoop/ssh/id_rsa.pri",
            require => File["${hadoop::params::hdadm}-ssh-dir"],
        }
    }elsif $hadoop::params::disable_auto_ssh == "true"{
        file { "/home/${hadoop::params::hdadm}/.ssh/id_rsa":
            ensure => absent,
        } 
    }
}


class hadoop::ssh::server inherits hadoop::ssh{

    if $hadoop::params::disable_auto_ssh == "false"{

        file { "/home/${hadoop::params::hdadm}/.ssh/authorized_keys":
            ensure => present,
            owner => "${hadoop::params::hdadm}",
            group => "${hadoop::params::hdgrp}",
            mode => "600",
            source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
            require => File["${hadoop::params::hdadm}-ssh-dir"],
        }
    }elsif $hadoop::params::disable_auto_ssh == "true"{
        exec {'remove public key in authorized_keys':
            command => "sed -i '/PUBKEY_BY_PUPPET/d' /home/${hadoop::params::hdadm}/.ssh/authorized_keys",
            path    => ["/bin", "/usr/bin", "/usr/sbin"],
        }
    }
}
    
