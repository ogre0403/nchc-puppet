#/etc/puppet/modules/hadoop/manifests/uninstall.pp

class hadoop::uninstall{

   file {'remove_directory':
        ensure => absent,
        path => '/opt/hadoop_version',
        recurse => true,
        purge => true,
        force => true,
    }

    file {'remove hadoop link':
        ensure => absent,
        path => '/opt/hadoop'
    }

    exec {'remove hadoop environment var':
        command => "sed -i '/SET_HADOOP_VAR_BY_PUPPET/d' /home/${hadoop::params::hdadm}/.bashrc",
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
    }

}
