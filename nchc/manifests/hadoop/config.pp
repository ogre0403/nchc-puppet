#/etc/puppet/modules/hadoop/manifests/config.pp

define multidir {
    exec { "mkdir ${name}":
        command => "mkdir -p ${name}",
        cwd => "${nchc::params::hadoop::hadoop_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        alias  => "dir-${name}",
        onlyif => "test ! -d ${name}",
    }

    file { "${name}":
        ensure => "directory",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        require => Exec["dir-${name}"],
    }
}

class nchc::hadoop::config{
    include nchc::params::hadoop
    include nchc::params::zookeeper

    file {"${nchc::params::hadoop::hadoop_tmp_path}":
        ensure => "directory",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        alias => "hadoop-tmp-dir",
     }
 
    multidir { $nchc::params::hadoop::namedir: 
        require => File["hadoop-tmp-dir"],
    }

    multidir { $nchc::params::hadoop::datadir: 
        require => File["hadoop-tmp-dir"],
    }

    multidir { $nchc::params::hadoop::journal_data_dir: 
        require => File["hadoop-tmp-dir"],
    }

    multidir { $nchc::params::hadoop::yarn_nodemanager_localdirs: 
        require => File["hadoop-tmp-dir"],
    }

    multidir { $nchc::params::hadoop::yarn_nodemanager_logdirs: 
        require => File["hadoop-tmp-dir"],
    }

    #file {$nchc::params::hadoop::namedir:
    #    ensure => "directory",
    #    owner => "${nchc::params::hadoop::hdadm}",
    #    group => "${nchc::params::hadoop::hdgrp}",
    #    require => File["hadoop-tmp-dir"],
    # }

    #file {$nchc::params::hadoop::datadir:
    #    ensure => "directory",
    #    owner => "${nchc::params::hadoop::hdadm}",
    #    group => "${nchc::params::hadoop::hdgrp}",
    #    require => File["hadoop-tmp-dir"],
    #}

    #file {$nchc::params::hadoop::journal_data_dir:
    #    ensure => "directory",
    #    owner => "${nchc::params::hadoop::hdadm}",
    #    group => "${nchc::params::hadoop::hdgrp}",
    #    require => File["hadoop-tmp-dir"],
    #}

    #file {$nchc::params::hadoop::yarn_nodemanager_localdirs:
    #    ensure => "directory",
    #    owner => "${nchc::params::hadoop::hdadm}",
    #    group => "${nchc::params::hadoop::hdgrp}",
    #    require => File["hadoop-tmp-dir"],
    #}

    #file {$nchc::params::hadoop::yarn_nodemanager_logdirs:
    #    ensure => "directory",
    #    owner => "${nchc::params::hadoop::hdadm}",
    #    group => "${nchc::params::hadoop::hdgrp}",
    #    require => File["hadoop-tmp-dir"],
    #}

    file {"${nchc::params::hadoop::hadoop_current}/bin/hdfs":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "755",
        alias => "hdfs-sh",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/hdfs.erb"),
    }

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/core-site.xml":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "664",
        alias => "core-site-xml",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/core-site.xml.erb"),
    }

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/hdfs-site.xml":
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        mode => "664",
        alias => "hdfs-site-xml",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/hdfs-site.xml.erb"),
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

    file {"${nchc::params::hadoop::hadoop_current}/lib/native/":
        ensure => directory,
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        recurse => true,
        purge => true,
        force => true,
        mode => 0755,
        source => "puppet:///modules/nchc/hadoop/lib/",  
        alias  => "native-lib",
    }

    if $nchc::params::hadoop::rack_aware == "yes"{
        file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/rack-topology.sh":
            ensure => "present",
            owner => "${nchc::params::hadoop::hdadm}",
            group => "${nchc::params::hadoop::hdgrp}",
            source => "puppet:///modules/nchc/hadoop/rack/rack-topology.sh",  
            #alias  => "rack-sh",
        }

        file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/rack_topology.data":
            ensure => "present",
            owner => "${nchc::params::hadoop::hdadm}",
            group => "${nchc::params::hadoop::hdgrp}",
            source => "puppet:///modules/nchc/hadoop/rack/rack_topology.data",  
            #alias  => "rack-data",
        }
    } elsif $nchc::params::hadoop::rack_aware == "no"{
        file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/rack-topology.sh":
            ensure => "absent",
        } 
        file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/rack_topology.data":
            ensure => "absent",
        }
    }

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/hadoop-metrics2.properties":
        ensure => "present",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/hadoop-metrics2.properties.erb"),
    }

    file {"${nchc::params::hadoop::hadoop_current}/etc/hadoop/capacity-scheduler.xml":
        ensure => "present",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/capacity-scheduler.xml.erb"),
    }

    if $nchc::params::hadoop::qjm_ha_mode == "no" and  
        "${nchc::params::hadoop::formatNN}" == "yes" {
        exec { "format NameNode":
            command => "${nchc::params::hadoop::hadoop_current}/bin/hadoop namenode -format",
            cwd => "${nchc::params::hadoop::hadoop_current}",
            alias => "format-NN",
            user => "${nchc::params::hadoop::hdadm}",
            path    => ["/bin", "/usr/bin", "/usr/sbin" ],
            onlyif =>"test  ! -d ${nchc::params::hadoop::namedir}/current",
            #onlyif =>"test ${nchc::params::hadoop::master} = $(facter hostname) -a ! -d ${nchc::params::hadoop::namedir}/current",
            require => [
                    File[$nchc::params::hadoop::namedir],
                    File[$nchc::params::hadoop::datadir],
                    File["hadoop-config"],
                    File["hadoop-env"],
                    File["slaves"],
                    File["hdfs-site-xml"],
                    File["core-site-xml"],
                    File["yarn-site-xml"],
                    File["native-lib"],
                    ],
        }
    } 

    if $nchc::params::hadoop::qjm_ha_mode == "yes" and 
        "${nchc::params::hadoop::master}" == "$::hostname" and 
        "${nchc::params::hadoop::formatNN}" == "yes" {
        file {"/tmp/format_HA_NN.sh":
            owner => "${nchc::params::hadoop::hdadm}",
            group => "${nchc::params::hadoop::hdgrp}",
            mode => "744",
            alias => "HA-NN-sh",
            content => template("nchc/hadoop/${nchc::params::hadoop::hadoop_version}/format_HA_NN.sh.erb"),
            require => [
                    File[$nchc::params::hadoop::namedir],
                    File[$nchc::params::hadoop::datadir],
                    File["hadoop-config"],
                    File["hadoop-env"],
                    File["slaves"],
                    File["hdfs-site-xml"],
                    File["core-site-xml"],
                    File["yarn-site-xml"],
                    File["native-lib"],
                    ],
        }

        exec { "format HA NameNode":
            command => "/tmp/format_HA_NN.sh",
            cwd => "${nchc::params::hadoop::hadoop_current}",
            alias => "format-HA-NN",
            user => "${nchc::params::hadoop::hdadm}",
            path    => ["/bin", "/usr/bin", "/usr/sbin","/tmp" ],
            onlyif =>"test ! -d ${nchc::params::hadoop::namedir}/current",
            require => File["HA-NN-sh"],
        }

        exec { " remove HA format script ":
            command => "rm /tmp/format_HA_NN.sh",
            cwd => "/tmp",
            user => "${nchc::params::hadoop::hdadm}",
            path    => ["/bin", "/usr/bin", "/usr/sbin"],
            require => Exec["format-HA-NN"],
            onlyif =>"test -e /tmp/format_HA_NN.sh",
        }
    }

}
