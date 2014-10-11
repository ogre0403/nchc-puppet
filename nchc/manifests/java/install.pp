# /etc/puppet/modules/java/manifests/install.pp

class nchc::java::install{
    require nchc::params::java

    file {"$nchc::params::java::java_base":
        ensure => "directory",
        owner => "root",
        group => "root",
        alias => "java-base",
#        before => Exec["download-java"],
        before => File["java-source-tgz"],
    }


#    exec { "download jdk${java::params::java_version}.tar.gz":
#        command => "curl -L '${java::params::jdk_url}' -H 'Cookie: oraclelicense=accept-securebackup-cookie' -o jdk${java::params::java_version}.tar.gz",
#        cwd => "${java::params::java_base}",
#        alias => "download-java",
#        before => Exec["untar-java"],
#        path    => ["/bin", "/usr/bin", "/usr/sbin"],
#        creates => "${java::params::java_base}/jdk${java::params::java_version}.tar.gz",
#    }

    file { "${nchc::params::java::java_base}/jdk${nchc::params::java::java_version}.tar.gz":
        mode => 0644,
        ensure => present,
        owner => "root",
        group => "root",
        alias => "java-source-tgz",
        before => Exec["untar-java"],
        source => "puppet:///modules/nchc/java/tarball/jdk${nchc::params::java::java_version}.tar.gz",
        #require => [File["java-base"], Exec["download-java"]],
        require => File["java-base"],
    }

    exec { "untar jdk${nchc::params::java::java_version}.tar.gz":
        command => "tar xfvz jdk${nchc::params::java::java_version}.tar.gz",
        cwd => "${nchc::params::java::java_base}",
        creates => "${nchc::params::java::java_base}/jdk${nchc::params::java::java_version}",
        alias => "untar-java",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${nchc::params::java::java_base}/jdk${nchc::params::java::java_version} | grep -c bin)",
        before => File["java-app-dir"],
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        require => File["java-source-tgz"]
    }

    file { "${nchc::params::java::java_base}/jdk${nchc::params::java::java_version}":
        ensure => "directory",
        mode => 0644,
        owner => "root",
        group => "root",
        alias => "java-app-dir",
        require => Exec["untar-java"],
    }

    exec{ "chown ${nchc::params::java::java_base}/jdk${nchc::params::java::java_version}  dir":
        command => "chown root:root -R jdk${nchc::params::java::java_version}",
        cwd => "${nchc::params::java::java_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        user => "root",
        onlyif => "test root != $(stat -c %U ${nchc::params::java::java_base}/jdk${nchc::params::java::java_version}/bin)",
        require => File["java-app-dir"],
    }



    file { "$nchc::params::java::java_current":
        ensure => 'link',
        target => "${nchc::params::java::java_base}/jdk${nchc::params::java::java_version}",
        alias => "java-link",
        require => File["java-app-dir"],
    }




#    exec { "set JAVA_HOME":
#        command => "echo 'export JAVA_HOME=${java::params::java_current}    # SET_JAVA_HOME_BY_PUPPET ' >> profile",
#        cwd => "/etc",
#        user => "root",
#        path    => ["/bin", "/usr/bin", "/usr/sbin"],
#        onlyif => "test 0 -eq $(grep -c JAVA_HOME /etc/profile)",
#        alias => "java-home",
#        require => File["java-link"]
#    }

#    exec { "set JAVA PATH":
#        command => "echo 'export PATH=\$PATH:\$JAVA_HOME/bin     # SET_JAVA_PATH_BY_PUPPET' >> profile",
#        cwd => "/etc",
#        user => "root",
#        path    => ["/bin", "/usr/bin", "/usr/sbin"],
#        onlyif => "test 0 -eq $(grep -c JAVA_HOME/bin /etc/profile)",
#        require => Exec["java-home"]
#    }


}

