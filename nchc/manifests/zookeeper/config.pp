# /etc/puppet/modules/zookeeper/manafests/init.pp

class nchc::zookeeper::config ($server_id) {

    require nchc::params::zookeeper

    exec { "mkdir ${nchc::params::zookeeper::zk_data_path}":
        command => "mkdir -p ${nchc::params::zookeeper::zk_data_path}",
        cwd => "${nchc::params::zookeeper::zk_base}/",
        alias => "create-zk-data-dir",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        onlyif => "test ! -d ${nchc::params::zookeeper::zk_data_path}",
        require => File["zk-app-dir"],
    }

    file { "${nchc::params::zookeeper::zk_data_path}":
        ensure => "directory",
        owner => "${nchc::params::zookeeper::zkadm}",
        group => "${nchc::params::zookeeper::zkgrp}",
        alias => "zk-data-dir",
        require => Exec["create-zk-data-dir"],
    }

    exec { "mkdir ${nchc::params::zookeeper::zk_log_path}":
        command => "mkdir -p ${nchc::params::zookeeper::zk_log_path}",
        cwd => "${nchc::params::zookeeper::zk_base}/",
        alias => "create-zk-log-dir",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        onlyif => "test ! -d ${nchc::params::zookeeper::zk_log_path}",
        require => File["zk-app-dir"],
    }

    file { "${nchc::params::zookeeper::zk_log_path}":
        ensure => "directory",
        owner => "${nchc::params::zookeeper::zkadm}",
        group => "${nchc::params::zookeeper::zkgrp}",
        alias => "zk-log-dir",
        require => Exec["create-zk-log-dir"],
    }
    
    file { "${nchc::params::zookeeper::zk_base}/${nchc::params::zookeeper::zk_version}/conf/zoo.cfg":
        owner => "${nchc::params::zookeeper::zkadm}",
        group => "${nchc::params::zookeeper::zkgrp}",
        alias => "zoo-cfg",
        require => File["zk-app-dir"],
        content => template("nchc/zookeeper/zoo.cfg.erb"),
    }

    file { "${nchc::params::zookeeper::zk_data_path}/myid":
        owner => "${nchc::params::zookeeper::zkadm}",
        group => "${nchc::params::zookeeper::zkgrp}",
        content => $server_id,
        require => File["zk-app-dir"],
        alias => "zookeeper-myid",
    }

}
