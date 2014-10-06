#/etc/puppet/modules/hadoop/manifests/init.pp

class hadoop{
    include hadoop::params
    
    file {"$hadoop::params::hadoop_base":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hadoop-base",
        before => File["hadoop-source-tgz"],
        #before => Exec["download-hadoop"],
    }
  
    
    #exec { "download ${hadoop::params::hadoop_version}.tar.gz":
    #    command => "wget ${hadoop::params::hadoop_url}",
    #    cwd => "${hadoop::params::hadoop_base}",
    #    alias => "download-hadoop",
    #    before => Exec["untar-hadoop"],
    #    path    => ["/bin", "/usr/bin", "/usr/sbin"],
    #    creates => "${hadoop::params::hadoop_base}/${hadoop::params::hadoop_version}.tar.gz",
    #}

    file { "${hadoop::params::hadoop_base}/${hadoop::params::hadoop_version}.tar.gz":
        mode => 0644,
        ensure => present,
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hadoop-source-tgz",
        before => Exec["untar-hadoop"],
        source => "puppet:///modules/hadoop/tarball/${hadoop::params::hadoop_version}.tar.gz",
        require => File["hadoop-base"], 
        #require => [File["hadoop-base"], Exec["download-hadoop"]],
    }



    exec { "untar ${hadoop::params::hadoop_version}.tar.gz":
        command => "tar xfvz ${hadoop::params::hadoop_version}.tar.gz",
        cwd => "${hadoop::params::hadoop_base}",
        creates => "${hadoop::params::hadoop_base}/${hadoop::params::hadoop_version}",
        alias => "untar-hadoop",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${hadoop::params::hadoop_base}/${hadoop::params::hadoop_version} | grep -c bin)",
        before => File["hadoop-app-dir"], 
        path   => ["/bin", "/usr/bin", "/usr/sbin"],  
        require => File["hadoop-source-tgz"],
    }                  

    file { "${hadoop::params::hadoop_base}/${hadoop::params::hadoop_version}":
        ensure => "directory", 
        mode => 0644,
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hadoop-app-dir",
        require => Exec["untar-hadoop"],
    }

    exec{ "chown ${hadoop::params::hadoop_version} dir":
        command => "chown ${hadoop::params::hdadm}:${hadoop::params::hdadm} -R ${hadoop::params::hadoop_version}",
        cwd => "${hadoop::params::hadoop_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],  
        user => "root",
        onlyif => "test ${hadoop::params::hdadm} != $(stat -c %U ${hadoop::params::hadoop_base}/${hadoop::params::hadoop_version}/bin)",
        require => File["hadoop-app-dir"],
    }

    file { "$hadoop::params::hadoop_current":
        ensure => 'link',
        target => "${hadoop::params::hadoop_base}/${hadoop::params::hadoop_version}",
        alias => "hadoop-link",
        require => File["hadoop-app-dir"],
    }

    file { "set environment var in .bashrc":
        path => "/home/${hadoop::params::hdadm}/.bashrc",
        ensure => present,
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        content => template("hadoop/bashrc.erb"),
        require => File["hadoop-link"],
    }

}


