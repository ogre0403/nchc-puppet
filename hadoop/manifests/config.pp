#/etc/puppet/modules/hadoop/manifests/config.pp

class hadoop::config{
    include hadoop::params

    file {"${hadoop::params::hadoop_current}/etc/hadoop/core-site.xml":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        mode => "664",
        alias => "core-site-xml",
        content => template("hadoop/conf/core-site.xml.erb"),
    }

    file {"${hadoop::params::hadoop_tmp_path}":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hadoop-tmp-dir",
     }
 

    file {"${hadoop::params::hadoop_current}/etc/hadoop/hdfs-site.xml":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        mode => "664",
        alias => "hdfs-site-xml",
        content => template("hadoop/conf/hdfs-site.xml.erb"),
    }

    file {"${hadoop::params::namedir}":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hadoop-name-dir",
        require => File["hadoop-tmp-dir"],
     }

    file {"${hadoop::params::datadir}":
        ensure => "directory",
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        alias => "hadoop-data-dir",
        require => File["hadoop-tmp-dir"],
    }

    file {"${hadoop::params::hadoop_current}/etc/hadoop/slaves":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        mode => "664",
        alias => "slaves",
        content => template("hadoop/conf/slaves.erb"),
    }

    file {"${hadoop::params::hadoop_current}/etc/hadoop/hadoop-env.sh":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        mode => "664",
        alias => "hadoop-env",
        content => template("hadoop/conf/hadoop-env.sh.erb"),
    }

    file {"${hadoop::params::hadoop_current}/libexec/hadoop-config.sh":
        owner => "${hadoop::params::hdadm}",
        group => "${hadoop::params::hdgrp}",
        mode => "664",
        alias => "hadoop-config",
        content => template("hadoop/conf/hadoop-config.sh.erb"),
    }


    exec { "format NameNode":
        command => "${hadoop::params::hadoop_current}/bin/hadoop namenode -format",
        cwd => "${hadoop::params::hadoop_current}",
        alias => "format-NN",
        user =>  "${hadoop::params::hdadm}",
        path    => ["/bin", "/usr/bin", "/usr/sbin" ],
        onlyif =>"test ${hadoop::params::master} = $(facter hostname) -a ! -d ${hadoop::params::namedir}/current",
        require => [File["hadoop-name-dir"],File["hadoop-data-dir"]],
    }

}
