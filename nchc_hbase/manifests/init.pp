# /etc/puppet/modules/zookeeper/manafests/init.pp

class nchc_hbase {

    require nchc_hbase::params
    require hadoop::params
    

    file {"$nchc_hbase::params::hbase_base":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hbase-base",
        before => File["hbase-tgz"],
    }


    file { "${nchc_hbase::params::hbase_base}/${nchc_hbase::params::hbase_version}.tar.gz":
        ensure => present,
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hbase-tgz",
        before => Exec["untar-hbase"],
        source => "puppet:///modules/nchc_hbase/tarball/${nchc_hbase::params::hbase_version}.tar.gz",
        require => File["hbase-base"],
    }

    exec { "untar ${nchc_hbase::params::hbase_version}.tar.gz":
        command => "tar xfvz ${nchc_hbase::params::hbase_version}.tar.gz",
        cwd => "${nchc_hbase::params::hbase_base}",
        creates => "${nchc_hbase::params::hbase_base}/${nchc_hbase::params::hbase_version}",
        alias => "untar-hbase",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${nchc_hbase::params::hbase_base}/${nchc_hbase::params::hbase_version} | grep -c bin)",
        before => File["hbase-app-dir"],
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        require => File["hbase-tgz"],
    }

    file { "${nchc_hbase::params::hbase_base}/${nchc_hbase::params::hbase_version}":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hbase-app-dir",
        require => Exec["untar-hbase"],
    }

    exec{ "chown ${nchc_hbase::params::hbase_version} dir":
        command => "chown ${hadoop::params::hdadm}:${hadoop::params::hdadm} -R ${nchc_hbase::params::hbase_version}",
        cwd => "${nchc_hbase::params::hbase_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        user => "root",
        onlyif => "test ${hadoop::params::hdadm} != $(stat -c %U ${nchc_hbase::params::hbase_base}/${nchc_hbase::params::hbase_version}/bin)",
        require => File["hbase-app-dir"],
    }

    file { "$nchc_hbase::params::hbase_current":
        ensure => 'link',
        target => "${nchc_hbase::params::hbase_base}/${nchc_hbase::params::hbase_version}",
        alias => "hbase-link",
        require => File["hbase-app-dir"],
    }

    
    file { "${nchc_hbase::params::hbase_base}/${nchc_hbase::params::hbase_version}/conf/regionservers":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "RS",
        require => File["hbase-app-dir"],
        content => template("nchc_hbase/conf/regionservers.erb"),
    }

    file { "${nchc_hbase::params::hbase_base}/${nchc_hbase::params::hbase_version}/conf/hbase-env.sh":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hbase-env",
        require => File["hbase-app-dir"],
        content => template("nchc_hbase/conf/hbase-env.sh.erb"),
    }

    file { "${nchc_hbase::params::hbase_base}/${nchc_hbase::params::hbase_version}/conf/hbase-site.xml":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hbase-site",
        require => File["hbase-app-dir"],
        content => template("nchc_hbase/conf/hbase-site.xml.erb"),
    }

}
