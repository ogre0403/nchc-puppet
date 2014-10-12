# /etc/puppet/modules/zookeeper/manafests/init.pp

class nchc::hbase::package {

    require nchc::params::hbase
    #require hadoop::params
    #require zookeeper::params
    

    file {"$nchc::params::hbase::hbase_base":
        ensure => "directory",
        owner => "${nchc::params::hbase::hbase_adm}",
        group => "${nchc::params::hbase::hbase_grp}",
        alias => "hbase-base",
        before => File["hbase-tgz"],
    }


    file { "${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}.tar.gz":
        ensure => present,
        owner => "${nchc::params::hbase::hbase_adm}",
        group => "${nchc::params::hbase::hbase_grp}",
        alias => "hbase-tgz",
        before => Exec["untar-hbase"],
        source => "puppet:///modules/nchc/hbase/tarball/${nchc::params::hbase::hbase_version}.tar.gz",
        require => File["hbase-base"],
    }

    exec { "untar ${nchc::params::hbase::hbase_version}.tar.gz":
        command => "tar xfvz ${nchc::params::hbase::hbase_version}.tar.gz",
        cwd => "${nchc::params::hbase::hbase_base}",
        creates => "${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}",
        alias => "untar-hbase",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version} | grep -c bin)",
        before => File["hbase-app-dir"],
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        require => File["hbase-tgz"],
    }

    file { "${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}":
        ensure => "directory",
        owner => "${nchc::params::hbase::hbase_adm}",
        group => "${nchc::params::hbase::hbase_grp}",
        alias => "hbase-app-dir",
        require => Exec["untar-hbase"],
    }

    exec{ "chown ${nchc::params::hbase::hbase_version} dir":
        command => "chown ${nchc::params::hbase::hbase_adm}:${nchc::params::hbase::hbase_grp} -R ${nchc::params::hbase::hbase_version}",
        cwd => "${nchc::params::hbase::hbase_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        user => "root",
        onlyif => "test ${nchc::params::hbase::hbase_adm} != $(stat -c %U ${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}/bin)",
        require => File["hbase-app-dir"],
    }

    file { "$nchc::params::hbase::hbase_current":
        ensure => 'link',
        target => "${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}",
        alias => "hbase-link",
        require => File["hbase-app-dir"],
    }

}
