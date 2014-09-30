#/etc/puppet/modules/hadoop/manifests/params.pp

class hadoop::params{

    $hdadm = $::hostname ? {
        default => "hdadm",
    }

    $hdgrp = $::hostname ? {
        default => "hdadm",
    }

    $disable_auto_ssh = $::hostname ? {
        default => "false",
    }
    
    $hadoop_version = $::hostname ? {
       default => "hadoop-2.0.0-cdh4.7.0",
    }

    $hadoop_url = $::hostname ? {
       default => "http://archive.cloudera.com/cdh4/cdh/4/hadoop-2.0.0-cdh4.7.0.tar.gz",
    }

    $hadoop_base = $::hostname ? {
        default     => "/opt/hadoop_version",
    }

    $hadoop_current = $::hostname ? {
        default     => "/opt/hadoop",
    }

}
