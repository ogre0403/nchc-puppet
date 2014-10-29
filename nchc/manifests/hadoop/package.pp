#/etc/puppet/modules/hadoop/manifests/init.pp

class nchc::hadoop::package{
    include nchc::params::hadoop
    
    file {"$nchc::params::hadoop::hadoop_base":
        ensure => "directory",
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
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

    file { "${nchc::params::hadoop::hadoop_base}/${nchc::params::hadoop::hadoop_version}.tar.gz":
        mode => 0644,
        ensure => present,
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        alias => "hadoop-source-tgz",
        before => Exec["untar-hadoop"],
        source => "puppet:///modules/nchc/hadoop/tarball/${nchc::params::hadoop::hadoop_version}.tar.gz",
        require => File["hadoop-base"], 
        #require => [File["hadoop-base"], Exec["download-hadoop"]],
    }



    exec { "untar ${nchc::params::hadoop::hadoop_version}.tar.gz":
        command => "tar xfvz ${nchc::params::hadoop::hadoop_version}.tar.gz",
        cwd => "${nchc::params::hadoop::hadoop_base}",
        creates => "${nchc::params::hadoop::hadoop_base}/${nchc::params::hadoop::hadoop_version}",
        alias => "untar-hadoop",
        user => "root",
        onlyif => "test 0 -eq $(ls -al ${nchc::params::hadoop::hadoop_base}/${nchc::params::hadoop::hadoop_version} | grep -c bin)",
        before => File["hadoop-app-dir"], 
        path   => ["/bin", "/usr/bin", "/usr/sbin"],  
        require => File["hadoop-source-tgz"],
    }                  

    file { "${nchc::params::hadoop::hadoop_base}/${nchc::params::hadoop::hadoop_version}":
        ensure => "directory", 
        mode => 0644,
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        alias => "hadoop-app-dir",
        require => Exec["untar-hadoop"],
    }

    exec{ "chown ${nchc::params::hadoop::hadoop_version} dir":
        command => "chown ${nchc::params::hadoop::hdadm}:${nchc::params::hadoop::hdadm} -R ${nchc::params::hadoop::hadoop_version}",
        cwd => "${nchc::params::hadoop::hadoop_base}/",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],  
        user => "root",
        onlyif => "test ${nchc::params::hadoop::hdadm} != $(stat -c %U ${nchc::params::hadoop::hadoop_base}/${nchc::params::hadoop::hadoop_version}/bin)",
        require => File["hadoop-app-dir"],
    }

    file { "$nchc::params::hadoop::hadoop_current":
        ensure => 'link',
        owner => "${nchc::params::hadoop::hdadm}",
        group => "${nchc::params::hadoop::hdgrp}",
        target => "${nchc::params::hadoop::hadoop_base}/${nchc::params::hadoop::hadoop_version}",
        alias => "hadoop-link",
        require => File["hadoop-app-dir"],
    }

    
    # only datanode need jsvc when kerberos is enabled
    if $nchc::params::hadoop::kerberos_mode == "yes" and
        "$::hostname" in $nchc::params::hadoop::slaves {
        
        file {"$nchc::params::hadoop::jsvc_base":
            ensure => "directory",
            owner => "${nchc::params::hadoop::hdadm}",
            group => "${nchc::params::hadoop::hdgrp}",
            alias => "jsvc-base",
            before => File["jsvc-tgz"],
        }
    
        file { "${nchc::params::hadoop::jsvc_base}/commons-daemon-1.0.15-src.tar.gz":
            mode => 0644,
            ensure => present,
            owner => "${nchc::params::hadoop::hdadm}",
            group => "${nchc::params::hadoop::hdgrp}",
            alias => "jsvc-tgz",
            before => Exec["untar-jsvc"],
            source => "puppet:///modules/nchc/hadoop/tarball/commons-daemon-1.0.15-src.tar.gz",
        }

        exec { "untar ${nchc::params::hadoop::jsvc_base}/commons-daemon-1.0.15-src.tar.gz":
            command => "tar xfvz ${nchc::params::hadoop::jsvc_base}/commons-daemon-1.0.15-src.tar.gz",
            cwd => "${nchc::params::hadoop::jsvc_base}",
            creates => "${nchc::params::hadoop::jsvc_base}/commons-daemon-1.0.15-src",
            alias => "untar-jsvc",
            user => "${nchc::params::hadoop::hdadm}",
            onlyif => "test 0 -eq $(ls -al ${nchc::params::hadoop::jsvc_base}/commons-daemon-1.0.15-src | grep -c src)",
            before => Exec["build-jsvc"], 
            path   => ["/bin", "/usr/bin", "/usr/sbin"],  
            require => File["jsvc-tgz"],
        }

        exec { "make jsvc":
            command => "./configure --with-java=${nchc::params::hadoop::hadoop_jdk}; make",
            cwd => "${nchc::params::hadoop::jsvc_base}/commons-daemon-1.0.15-src/src/native/unix",
            alias => "build-jsvc",
            user => "${nchc::params::hadoop::hdadm}",
            #require => [ Package["make"], Package["gcc"] ],
            path    => ["/bin", "/usr/bin", "/usr/sbin", "${nchc::params::hadoop::jsvc_base}/commons-daemon-1.0.15-src/src/native/unix"],
            creates => "${nchc::params::hadoop::jsvc_base}/commons-daemon-1.0.15-src/src/native/unix/jsvc",
        }

        file { "$nchc::params::hadoop::jsvc_path":
            ensure => 'link',
            owner => "${nchc::params::hadoop::hdadm}",
            group => "${nchc::params::hadoop::hdgrp}",
            target => "${nchc::params::hadoop::jsvc_base}/commons-daemon-1.0.15-src/src/native/unix",
            require => Exec["build-jsvc"],
        }
    }


}


