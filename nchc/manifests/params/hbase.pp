# /etc/puppet/modules/nchc-hbase/manafests/params.pp

class nchc::params::hbase {
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
        default     => ["NN-agent"]
    }

    $hbase_regionservers = $::hostname ? {
        default     => ["DN1-agent"]
    }

    $zookeeper_quorum = $::hostname ? {
        default     => ["NN-agent"],
    }
 
    $hbase_dir = $::hostname ? {
        default     => "hbase",
    }

}
