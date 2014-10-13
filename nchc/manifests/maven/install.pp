# /etc/puppet/modules/java/manifests/install.pp

class nchc::maven::install{
    require nchc::params::maven

    file {"$nchc::params::maven::mvn_base":
        ensure => "directory",
        owner => "root",
        group => "root",
        alias => "mvn-base",
        before => File["mvn-source-tgz"],
    }


    file { "${nchc::params::maven::mvn_base}/${nchc::params::maven::mvn_version}-bin.tar.gz":
        mode => 0644,
        ensure => present,
        owner => "root",
        group => "root",
        alias => "mvn-source-tgz",
        before => Exec["untar-mvn"],
        source => "puppet:///modules/nchc/maven/tarball/${nchc::params::maven::mvn_version}-bin.tar.gz",
        #require => [File["java-base"], Exec["download-java"]],
        require => File["mvn-base"],
    }

    exec { "untar ${nchc::params::maven::mvn_version}-bin.tar.gz":
        command => "tar xfvz ${nchc::params::maven::mvn_version}-bin.tar.gz",
        cwd => "${nchc::params::maven::mvn_base}",
        creates => "${nchc::params::maven::mvn_base}/${nchc::params::maven::mvn_version}",
        alias => "untar-mvn",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${nchc::params::maven::mvn_base}/${nchc::params::maven::mvn_version} | grep -c bin)",
        before => File["mvn-app-dir"],
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        require => File["mvn-source-tgz"]
    }

    file { "${nchc::params::maven::mvn_base}/${nchc::params::maven::mvn_version}":
        ensure => "directory",
        mode => 0644,
        owner => "root",
        group => "root",
        alias => "mvn-app-dir",
        require => Exec["untar-mvn"],
    }

    exec{ "chown ${nchc::params::maven::mvn_base}/${nchc::params::maven::mvn_version}  dir":
        command => "chown root:root -R ${nchc::params::maven::mvn_version}",
        cwd => "${nchc::params::maven::mvn_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        user => "root",
        onlyif => "test root != $(stat -c %U ${nchc::params::maven::mvn_base}/${nchc::params::maven::mvn_version}/bin)",
        require => File["mvn-app-dir"],
    }



    file { "$nchc::params::maven::mvn_current":
        ensure => 'link',
        target => "${nchc::params::maven::mvn_base}/${nchc::params::maven::mvn_version}",
        alias => "mvn-link",
        require => File["mvn-app-dir"],
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

