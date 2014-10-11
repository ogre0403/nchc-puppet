# /etc/puppet/modules/zookeeper/manafests/init.pp

class nchc::zookeeper::package {

    require nchc::params::zookeeper
    

    file {"$nchc::params::zookeeper::zk_base":
        ensure => "directory",
        owner => "${nchc::params::zookeeper::zkadm}",
        group => "${nchc::params::zookeeper::zkgrp}",
        alias => "zk-base",
        before => File["zk-tgz"],
    }


    file { "${nchc::params::zookeeper::zk_base}/${nchc::params::zookeeper::zk_version}.tar.gz":
        mode => 0644,
        ensure => present,
        owner => "${nchc::params::zookeeper::zkadm}",
        group => "${nchc::params::zookeeper::zkgrp}",
        alias => "zk-tgz",
        before => Exec["untar-zk"],
        source => "puppet:///modules/nchc/zookeeper/tarball/${nchc::params::zookeeper::zk_version}.tar.gz",
        require => File["zk-base"],
    }

    exec { "untar ${nchc::params::zookeeper::zk_version}.tar.gz":
        command => "tar xfvz ${nchc::params::zookeeper::zk_version}.tar.gz",
        cwd => "${nchc::params::zookeeper::zk_base}",
        creates => "${nchc::params::zookeeper::zk_base}/${nchc::params::zookeeper::zk_version}",
        alias => "untar-zk",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${nchc::params::zookeeper::zk_base}/${nchc::params::zookeeper::zk_version} | grep -c bin)",
        before => File["zk-app-dir"],
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        require => File["zk-tgz"],
    }

    file { "${nchc::params::zookeeper::zk_base}/${nchc::params::zookeeper::zk_version}":
        ensure => "directory",
        owner => "${nchc::params::zookeeper::zkadm}",
        group => "${nchc::params::zookeeper::zkgrp}",
        alias => "zk-app-dir",
        require => Exec["untar-zk"],
    }

    exec{ "chown ${nchc::params::zookeeper::zk_version} dir":
        command => "chown ${nchc::params::zookeeper::zkadm}:${nchc::params::zookeeper::zkgrp} -R ${nchc::params::zookeeper::zk_version}",
        cwd => "${nchc::params::zookeeper::zk_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        user => "root",
        onlyif => "test ${nchc::params::zookeeper::zkadm} != $(stat -c %U ${nchc::params::zookeeper::zk_base}/${nchc::params::zookeeper::zk_version}/bin)",
        require => File["zk-app-dir"],
    }

    file { "$nchc::params::zookeeper::zk_current":
        ensure => 'link',
        target => "${nchc::params::zookeeper::zk_base}/${nchc::params::zookeeper::zk_version}",
        alias => "zk-link",
        require => File["zk-app-dir"],
    }

}
