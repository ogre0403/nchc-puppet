#/etc/puppet/modules/nchc/manifests/ssh/ssh.pp

class nchc::ssh::server inherits nchc::ssh::base{

    if $nchc::params::ssh::auto_login == "true"{

        ssh_authorized_key { "${nchc::params::ssh::user}@PUBKEY_BY_PUPPET":
            user => "${nchc::params::ssh::user}",
            type => 'ssh-rsa',
            key  => "${nchc::params::ssh::pubkey}",
        }

    }elsif $nchc::params::ssh::auto_login == "false"{
        
        ssh_authorized_key { "${nchc::params::ssh::user}@PUBKEY_BY_PUPPET":
            user => "${nchc::params::ssh::user}",
            type => 'ssh-rsa',
            ensure         => absent,
        }
    }
}
    
