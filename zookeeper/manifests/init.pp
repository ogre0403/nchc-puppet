# /etc/puppet/modules/zookeeper/manafests/init.pp

class zookeeper ($server_id) {

    require zookeeper::params
    

    file {"$zookeeper::params::zk_base":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "zk-base",
        before => File["zk-tgz"],
    }


    file { "${zookeeper::params::zk_base}/${zookeeper::params::zk_version}.tar.gz":
        mode => 0644,
        ensure => present,
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "zk-tgz",
        before => Exec["untar-zk"],
        source => "puppet:///modules/zookeeper/tarball/${zookeeper::params::zk_version}.tar.gz",
        require => File["zk-base"],
    }

    exec { "untar ${zookeeper::params::zk_version}.tar.gz":
        command => "tar xfvz ${zookeeper::params::zk_version}.tar.gz",
        cwd => "${zookeeper::params::zk_base}",
        creates => "${zookeeper::params::zk_base}/${zookeeper::params::zk_version}",
        alias => "untar-zk",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${zookeeper::params::zk_base}/${zookeeper::params::zk_version} | grep -c bin)",
        before => File["zk-app-dir"],
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        require => File["zk-tgz"],
    }

    file { "${zookeeper::params::zk_base}/${zookeeper::params::zk_version}":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "zk-app-dir",
        require => Exec["untar-zk"],
    }

    exec{ "chown ${zookeeper::params::zk_version} dir":
        command => "chown ${hadoop::params::hdadm}:${hadoop::params::hdadm} -R ${zookeeper::params::zk_version}",
        cwd => "${zookeeper::params::zk_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        user => "root",
        onlyif => "test ${hadoop::params::hdadm} != $(stat -c %U ${zookeeper::params::zk_base}/${zookeeper::params::zk_version}/bin)",
        require => File["zk-app-dir"],
    }

    file { "$zookeeper::params::zk_current":
        ensure => 'link',
        target => "${zookeeper::params::zk_base}/${zookeeper::params::zk_version}",
        alias => "zk-link",
        require => File["zk-app-dir"],
    }

    exec { "mkdir ${zookeeper::params::zk_data_path}":
        command => "mkdir -p ${zookeeper::params::zk_data_path}",
        cwd => "${zookeeper::params::zk_base}/",
        alias => "zk-data-dir",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        onlyif => "test ! -d ${zookeeper::params::zk_data_path}",
        require => File["zk-app-dir"],
    }

    exec { "mkdir ${zookeeper::params::zk_log_path}":
        command => "mkdir -p ${zookeeper::params::zk_log_path}",
        cwd => "${zookeeper::params::zk_base}/",
        alias => "zk-log-dir",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        onlyif => "test ! -d ${zookeeper::params::zk_log_path}",
        require => File["zk-app-dir"],
    }
    
    file { "${zookeeper::params::zk_base}/${zookeeper::params::zk_version}/conf/zoo.cfg":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "zoo-cfg",
        require => File["zk-app-dir"],
        content => template("zookeeper/zoo.cfg.erb"),
    }

    file { "${zookeeper::params::zk_data_path}/myid":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        content => $server_id,
        require => File["zk-app-dir"],
        alias => "zookeeper-myid",
    }

}
