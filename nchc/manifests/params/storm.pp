#/etc/puppet/modules/nchc/manifests/params/storm.pp

class nchc::params::storm {

    $storm_adm = $::hostname ? {
        default => "hdadm",
    }          

    $storm_grp = $::hostname ? {
        default => "hdadm",
    }
          
    $storm_version = $::hostname ? {
        default => "apache-storm-0.9.2-incubating",
    }          

    $storm_base = $::hostname ? {
        default => "/opt/storm_version",
    }          

    $storm_current = $::hostname ? {
        default => "/opt/storm",
    }          
    
    $storm_nimbus = $::hostname ? {
        default => "NN-agent",
    }          
    
    $storm_supervisor = $::hostname ? {
        default => ["6700","6701","6702","6703"],
    }          
    
    $storm_local_dir = $::hostname ? {
        default => "/opt/storm_dir",
    }          
    
    $storm_zk_server = $::hostname ? {
        default => ["NN-agent"],
    }          

    $storm_on_yarn = $::hostname ? {
        default => "no",
    }          

    $storm_on_yarn_dir = $::hostname ? {
        default => "${storm_base}/storm-yarn",
    }          
}
