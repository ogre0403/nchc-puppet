# /etc/puppet/modules/java/manifests/install.pp

class java::install{
    require java::params
    file {"$java::params::java_base":
        ensure => "directory",
        owner => "root",
        group => "root",
        alias => "java-base",
        before => Exec["download-java"],
    }

    exec { "download jdk${java::params::java_version}.tar.gz":
        command => "curl -L '${java::params::jdk_url}' -H 'Cookie: oraclelicense=accept-securebackup-cookie' -o jdk${java::params::java_version}.tar.gz",
        cwd => "${java::params::java_base}",
        alias => "download-java",
        before => Exec["untar-java"],
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
        #onlyif => "test -d ${java::params::java_base}/jdk${java::params::java_version}",
        creates => "${java::params::java_base}/jdk${java::params::java_version}.tar.gz",
    }

    file { "${java::params::java_base}/jdk${java::params::java_version}.tar.gz":
        mode => 0644,
        ensure => present,
        owner => "root",
        group => "root",
        alias => "java-source-tgz",
        before => Exec["untar-java"],
        require => [File["java-base"], Exec["download-java"]],
    }

    exec { "untar jdk${java::params::java_version}.tar.gz":
        command => "tar xfvz jdk${java::params::java_version}.tar.gz",
        cwd => "${java::params::java_base}",
        creates => "${java::params::java_base}/jdk${java::params::java_version}",
        alias => "untar-java",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${java::params::java_base}/jdk${java::params::java_version} | grep -c bin)",
        before => File["java-app-dir"],
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        require => File["java-source-tgz"]
    }

    file { "${java::params::java_base}/jdk${java::params::java_version}":
        ensure => "directory",
        mode => 0644,
        owner => "root",
        group => "root",
        alias => "java-app-dir",
        require => Exec["untar-java"],
    }

    file { "$java::params::java_current":
        ensure => 'link',
        target => "${java::params::java_base}/jdk${java::params::java_version}",
        alias => "java-link",
        require => File["java-app-dir"],
    }

    exec { "set JAVA_HOME":
        command => "echo 'export JAVA_HOME=${java::params::java_current}    # SET_JAVA_HOME_BY_PUPPET ' >> profile",
        cwd => "/etc",
        user => "root",
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
        onlyif => "test 0 -eq $(grep -c JAVA_HOME /etc/profile)",
        alias => "java-home",
        require => File["java-link"]
    }

    exec { "set JAVA PATH":
        command => "echo 'export PATH=\$PATH:\$JAVA_HOME/bin     # SET_JAVA_PATH_BY_PUPPET' >> profile",
        cwd => "/etc",
        user => "root",
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
        onlyif => "test 0 -eq $(grep -c JAVA_HOME/bin /etc/profile)",
        require => Exec["java-home"]
    }


}

