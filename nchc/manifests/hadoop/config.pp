#/etc/puppet/modules/hadoop/manifests/config.pp

class nchc::hadoop::config{
    include nchc::params::hadoop

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/core-site.xml":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "664",
        alias => "core-site-xml",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/core-site.xml.erb"),
    }

    file {"${nchc::params::hadoop::hadoop_tmp_path}":
        ensure => "directory",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        alias => "hadoop-tmp-dir",
     }
 

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/hdfs-site.xml":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "664",
        alias => "hdfs-site-xml",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/hdfs-site.xml.erb"),
    }

    file {"${nchc::params::hadoop::namedir}":
        ensure => "directory",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        alias => "hadoop-name-dir",
        require => File["hadoop-tmp-dir"],
     }

    file {"${nchc::params::hadoop::datadir}":
        ensure => "directory",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        alias => "hadoop-data-dir",
        require => File["hadoop-tmp-dir"],
    }

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/slaves":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "664",
        alias => "slaves",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/slaves.erb"),
    }

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/hadoop-env.sh":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "664",
        alias => "hadoop-env",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/hadoop-env.sh.erb"),
    }

    file {"${nchc::params::hadoop::hadoop_current}/libexec/hadoop-config.sh":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "664",
        alias => "hadoop-config",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/hadoop-config.sh.erb"),
    }


    exec { "format NameNode":
        command => "${nchc::params::hadoop::hadoop_current}/bin/hadoop namenode -format",
        cwd => "${nchc::params::hadoop::hadoop_current}",
        alias => "format-NN",
        user => "${nchc::params::hadoop::hdadm}",
        path    => ["/bin", "/usr/bin", "/usr/sbin" ],
        onlyif =>"test ${nchc::params::hadoop::master} = $(facter hostname) -a ! -d ${nchc::params::hadoop::namedir}/current",
        require => [
                    File["hadoop-name-dir"],
                    File["hadoop-data-dir"],
                    File["hadoop-config"],
                    File["hadoop-env"],
                    File["slaves"],
                    File["hdfs-site-xml"],
                    File["core-site-xml"],
                    ],
    }

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/mapred-site.xml":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "664",
        alias => "mapred-site-xml",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/mapred-site.xml.erb"),
    }

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/yarn-site.xml":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "664",
        alias => "yarn-site-xml",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/yarn-site.xml.erb"),
    }

    file {"${nchc::params::hadoop::yarn_nodemanager_localdirs}":
        ensure => "directory",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        alias => "yarn-nm-localdir",
        require => File["hadoop-tmp-dir"],
    }

    file {"${nchc::params::hadoop::yarn_nodemanager_logdirs}":
        ensure => "directory",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        alias => "yarn-nm-logdir",
        require => File["hadoop-tmp-dir"],
    }
}
