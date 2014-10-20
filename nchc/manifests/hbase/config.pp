# /etc/puppet/modules/zookeeper/manafests/init.pp

class nchc::hbase::config {

    require nchc::params::hbase
    #require hadoop::params
    #require zookeeper::params
    

    
    file { "${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}/conf/regionservers":
        owner => "${nchc::params::hbase::hbase_adm}",
        group => "${nchc::params::hbase::hbase_grp}",
        alias => "RS",
        require => File["hbase-app-dir"],
        content => template("nchc/hbase/${nchc::params::hbase::hbase_version}/regionservers.erb"),
    }

    file { "${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}/conf/hbase-env.sh":
        owner => "${nchc::params::hbase::hbase_adm}",
        group => "${nchc::params::hbase::hbase_grp}",
        alias => "hbase-env",
        require => File["hbase-app-dir"],
        content => template("nchc/hbase/${nchc::params::hbase::hbase_version}/hbase-env.sh.erb"),
    }

    file { "${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}/conf/hbase-site.xml":
        owner => "${nchc::params::hbase::hbase_adm}",
        group => "${nchc::params::hbase::hbase_grp}",
        alias => "hbase-site",
        require => File["hbase-app-dir"],
        content => template("nchc/hbase/${nchc::params::hbase::hbase_version}/hbase-site.xml.erb"),
    }

    file { "${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}/conf/core-site.xml":
        ensure => 'link',
        target => "${nchc::params::hbase::hadoop_conf_path}/core-site.xml",
        owner => "${nchc::params::hbase::hbase_adm}",
        group => "${nchc::params::hbase::hbase_grp}",
    }

    file { "${nchc::params::hbase::hbase_base}/${nchc::params::hbase::hbase_version}/conf/hdfs-site.xml":
        ensure => 'link',
        target => "${nchc::params::hbase::hadoop_conf_path}/hdfs-site.xml",
        owner  => "${nchc::params::hbase::hbase_adm}",
        group  => "${nchc::params::hbase::hbase_grp}",
    }
}
