# /etc/puppet/modules/nchc-hbase/manafests/params.pp

class nchc::params::hbase {

    $hbase_adm = $::hostname ? {
       default => "vagrant",
    }

    $hbase_grp = $::hostname ? {
       default => "vagrant",
    }

    $hbase_jdk = $::hostname ? {
       default => "/opt/java",
    }

    $hbase_hdfs = $::hostname ? {
       default => "NN",
    }

    $hbase_hdfsport = $::hostname ? {
       default => "9000",
    }

    $hbase_version = $::hostname ? {
       default => "hbase-0.94.15-cdh4.7.0",
    }

    $hbase_base = $::hostname ? {
        default     => "/opt/hbase_version",
    }

    $hbase_current = $::hostname ? {
        default     => "/opt/hbase",
    }

    $hbase_master = $::hostname ? {
        default     => ["NN"]
    }

    $hbase_regionservers = $::hostname ? {
        default     => ["DN1"]
    }

    $zookeeper_quorum = $::hostname ? {
        default     => ["NN"],
    }
 
    $hbase_dir = $::hostname ? {
        default     => "hbase",
    }

}
