#/etc/puppet/modules/NCHC/manifests/storm/storm.pp

class nchc::storm::install {

    include nchc::params::storm

    file {"$nchc::params::storm::storm_base":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "storm-base",
        before => File["storm-tgz"],
    }


    file { "${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}.tar.gz":
        ensure => present,
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
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
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "storm-app-dir",
        require => Exec["untar-storm"],
    }

    exec{ "chown ${nchc::params::storm::storm_version} dir":
        command => "chown ${hadoop::params::hdadm}:${hadoop::params::hdadm} -R ${nchc::params::storm::storm_version}",
        cwd => "${nchc::params::storm::storm_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        user => "root",
        onlyif => "test ${hadoop::params::hdadm} != $(stat -c %U ${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}/bin)",           require => File["storm-app-dir"],
    }

    file { "$nchc::params::storm::storm_current":
        ensure => 'link',
        target => "${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}",
        alias => "storm-link",
        require => File["storm-app-dir"],
    }
     

    exec { "mkdir ${nchc::params::storm::storm_local_dir}":
        command => "mkdir -p ${nchc::params::storm::storm_local_dir}",
        cwd => "${nchc::params::storm::storm_base}/",
        alias => "create-storm-local-dir",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        onlyif => "test ! -d ${nchc::params::storm::storm_local_dir}",
        require => File["storm-app-dir"],
    }

    file { "${nchc::params::storm::storm_local_dir}":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "storm-local-dir",
        require => Exec["create-storm-local-dir"],
    }

    file { "${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}/conf/storm.yaml":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "storm-yaml",
        require => File["storm-app-dir"],
        content => template("nchc/storm/storm.yaml.erb"),
    }


}
