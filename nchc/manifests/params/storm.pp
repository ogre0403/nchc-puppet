#/etc/puppet/modules/nchc/manifests/params/storm.pp

class nchc::params::storm {

    $storm_adm = $::hostname ? {
        default => "vagrant",
    }          

    $storm_grp = $::hostname ? {
        default => "vagrant",
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
        default => "NN",
    }          
    
    $storm_supervisor = $::hostname ? {
        default => ["6700","6701","6702","6703"],
    }          
    
    $storm_local_dir = $::hostname ? {
        default => "/tmp/storm",
    }          
    
    $storm_zk_server = $::hostname ? {
        default => ["NN"],
    }          
}
