# /etc/puppet/modules/java/manifests/uninstall.pp

class java::uninstall{
    
    file {'remove_directory':
        ensure => absent,
        path => '/opt/java_version',
        recurse => true,
        purge => true,
        force => true,
    }

    file {'remove JVM link':
        ensure => absent,
        path => '/opt/java'
    }

    exec {'remove JAVA_HOME':
        command => "sed -i '/SET_JAVA_HOME_BY_PUPPET/d' /etc/profile",
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
        alias   => "remove-java-home",
    }

    exec {'remove JAVA_PATH':
        command => "sed -i '/SET_JAVA_PATH_BY_PUPPET/d' /etc/profile",
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
        alias   => "remove-java-path",
        require => Exec["remove-java-home"],
    }
}
