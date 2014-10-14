#/etc/puppet/modules/NCHC/manifests/storm/storm.pp

class nchc::storm::package {

    include nchc::params::storm

    file {"$nchc::params::storm::storm_base":
        ensure => "directory",
        owner => "${nchc::params::storm::storm_adm}",
        group => "${nchc::params::storm::storm_grp}",
        alias => "storm-base",
        before => File["storm-tgz"],
    }


    file { "${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}.tar.gz":
        ensure => present,
        owner => "${nchc::params::storm::storm_adm}",
        group => "${nchc::params::storm::storm_grp}",
        alias => "storm-tgz",
        before => Exec["untar-storm"],
        source => "puppet:///modules/nchc/storm/tarball/${nchc::params::storm::storm_version}.tar.gz",
        require => File["storm-base"],
    }

    exec { "untar ${nchc::params::storm::storm_version}.tar.gz":
        command => "tar xfvz ${nchc::params::storm::storm_version}.tar.gz",
        cwd => "${nchc::params::storm::storm_base}",
        creates => "${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}",
        alias => "untar-storm",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version} | grep -c bin)",
        before => File["storm-app-dir"],
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        require => File["storm-tgz"],
    }

    file { "${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}":
        ensure => "directory",
        owner => "${nchc::params::storm::storm_adm}",
        group => "${nchc::params::storm::storm_grp}",
        alias => "storm-app-dir",
        require => Exec["untar-storm"],
    }

    exec{ "chown ${nchc::params::storm::storm_version} dir":
        command => "chown ${nchc::params::storm::storm_adm}:${nchc::params::storm::storm_grp} -R ${nchc::params::storm::storm_version}",
        cwd => "${nchc::params::storm::storm_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        user => "root",
        onlyif => "test ${nchc::params::storm::storm_adm} != $(stat -c %U ${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}/bin)",           require => File["storm-app-dir"],
    }

    file { "$nchc::params::storm::storm_current":
        ensure => 'link',
        target => "${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}",
        alias => "storm-link",
        require => File["storm-app-dir"],
    }

    if $nchc::params::storm::storm_on_yarn == "yes"{
        file { "${nchc::params::storm::storm_base}/storm-yarn-CDH.tar.gz":
            ensure => present,
            owner => "${nchc::params::storm::storm_adm}",
            group => "${nchc::params::storm::storm_grp}",
            alias => "storm-yarn-tgz",
            before => Exec["untar-storm-yarn"],
            source => "puppet:///modules/nchc/storm/tarball/storm-yarn-CDH.tar.gz",
            require => File["storm-base"],
        }

        exec { "untar storm-yarn-CDH.tar.gz":
            command => "tar xfvz storm-yarn-CDH.tar.gz",
            cwd => "${nchc::params::storm::storm_base}",
            creates => "${nchc::params::storm::storm_base}/storm-yarn",
            alias => "untar-storm-yarn",
            user => "root",
            onlyif => "test 0 -eq $(ls -al ${nchc::params::storm::storm_base}/storm-yarn | grep -c bin)",
            path   => ["/bin", "/usr/bin", "/usr/sbin"],
            require => File["storm-yarn-tgz"],
        }
    }elsif $nchc::params::storm::storm_on_yarn == "no"{
    
        file { "${nchc::params::storm::storm_base}/storm-yarn-CDH.tar.gz":
            ensure => absent,
        }

        file { "${nchc::params::storm::storm_base}/storm-yarn":
            ensure => absent,
            recurse => true,
            purge => true,
            force => true,
        }
    }

}
