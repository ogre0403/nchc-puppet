#/etc/puppet/modules/hadoop/manifests/params.pp

class nchc::params::hadoop{

    $hdadm = $::hostname ? {
        default => "hdadm",
    }

    $hdgrp = $::hostname ? {
        default => "hdadm",
    }

    $hadoop_jdk = $::hostname ? {
        default => "/opt/java",
    }

    $hadoop_version = $::hostname ? {
       default => "hadoop-2.0.0-cdh4.7.0",
       #default => "hadoop-2.3.0-cdh5.0.2",
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

    #slaves
    $slaves = $::hostname ? {
        default  => ["DN1-agent","DN2-agent"],
    }

    # core-site.xml
    $master = $::hostname ? {
        default  => "NN-agent",
    }

    $hdfsport = $::hostname ? {
        default  => "9000",
    }

    $hadoop_tmp_path = $::hostname ? {
        default  => "/opt/hadoop_dir",
    }
    
    # hdfs-site.xml
    $replica_factor = $::hostname ? {
        default  => "1",
    }

    $namedir = $::hostname ? {
        default  => ["${hadoop_tmp_path}/name1"],
    }

    $datadir = $::hostname ? {
        default  => ["${hadoop_tmp_path}/data1"],
    }

    #yarn-site.pp
    
    $resource_tracker_port = $::hostname ? {
        default  => "8031",
    }

    $scheduler_port = $::hostname ? {
        default  => "8030",
    }

    $resourcemanager_port = $::hostname ? {
        default  => "8032",
    }

    $resourcemanager_adminport = $::hostname ? {
        default  => "8033",
    }

    $resourcemanager_webport = $::hostname ? {
        default  => "8088",
    }

    $yarn_nodemanager_localdirs = $::hostname ? {
        default  => ["${hadoop_tmp_path}/nm-local-dir"],
    }

    $yarn_nodemanager_logdirs = $::hostname ? {
        default  => ["${hadoop_tmp_path}/userlogs"],
    }

    $yarn_remote_logdirs = $::hostname ? {
        default  => "/var/log/hadoop-yarn/apps",
    }

    $yarn_rm_mem = $::hostname ? {
        default  => "1024",
    }

    $yarn_schedule_min = $::hostname ? {
        default  => "256",
    }

    $yarn_schedule_max = $::hostname ? {
        default  => "1024",
    }

    $yarn_mr_am = $::hostname ? {
        default  => "1024",
    }

    $yarn_mr_am_opt = $::hostname ? {
        default  => "800m",
    }

    $qjm_ha_mode = $::hostname ? {
        default  => "yes",
    }


    if $qjm_ha_mode == "yes" {

        $dfs_nameservices = "MYHDFS"
        $standby_master = "NN"
        $journalnodes = ["NN-agent", "DN1-agent", "DN2-agent" ]
        $journal_data_dir = "${hadoop_tmp_path}/journaldata"
        $zookeeper_quorum = ["NN-agent"]

    } elsif $qjm_ha_mode == "no" {

        $dfs_nameservices = undef
        $standby_master = undef
        $journalnodes = under
        $journal_data_dir = undef
        $zookeeper_quorum = undef
    }
}

