# /etc/puppet/modules/zookeeper/manafests/init.pp

class nchc::params::zookeeper{

    $zkadm = $::hostname ? {
       default => "vagrant",
    }

    $zkgrp = $::hostname ? {
       default => "vagrant",
    }

    $zk_version = $::hostname ? {
       default => "zookeeper-3.4.5-cdh4.7.0",
    }

    $zk_base = $::hostname ? {
        default     => "/opt/zookeeper_version",
    }

    $zk_current = $::hostname ? {
        default     => "/opt/zookeeper",
    }
 
    $zk_data_path = $::hostname ? {
        default     => "/tmp/zookeeper/data",
    }

    $zk_log_path = $::hostname ? {
        default     => "/tmp/zookeeper/log",
    }

    $zk_servers = $::hostname ? {
        default         => ["NN"] 
    }

    
}
