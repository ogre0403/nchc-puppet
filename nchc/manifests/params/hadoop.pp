#/etc/puppet/modules/hadoop/manifests/params.pp

class nchc::params::hadoop{

    $hdadm = "hdadm"
    $hdgrp = "hdadm"
    $hadoop_jdk = "/opt/java"

    $hadoop_version = "hadoop-2.0.0-cdh4.7.0"
    #default => "hadoop-2.3.0-cdh5.0.2",
    $hadoop_base =  "/opt/hadoop_version"
    $hadoop_current = "/opt/hadoop"
    #slaves
    $slaves = ["DN1-agent","DN2-agent"]
    

    # core-site.xml
    $master = "NN-agent"
    $hdfsport = "9000"
    $hadoop_tmp_path  = "/opt/hadoop_dir"
    
    # hdfs-site.xml
    $replica_factor = "1"
    $namedir =  ["${hadoop_tmp_path}/name1"]
    $datadir =  ["${hadoop_tmp_path}/data1"]

    $namenode_heap = "512m"

    #yarn-site.pp
    $resourcemanager =  "${master}"
    $resource_tracker_port =  "8031"
    $scheduler_port = "8030"
    $resourcemanager_port = "8032"
    $resourcemanager_adminport = "8033"
    $resourcemanager_webport =  "8088"
    $yarn_nodemanager_localdirs =  ["${hadoop_tmp_path}/nm-local-dir"]
    $yarn_nodemanager_logdirs =  ["${hadoop_tmp_path}/userlogs"]
    $yarn_remote_logdirs = "/var/log/hadoop-yarn/apps"
    $yarn_rm_mem = "4096"
    $yarn_schedule_min =  "1024"
    $yarn_schedule_max = "2048"
    $yarn_mr_am = "2048"
    $yarn_mr_am_opt = "800m"

    #mapred-site.xml
    $histroyserver = "NN-agent"
    $map_mem = "1024"
    $reduce_mem = "1024"
    $map_opt = "800m"
    $reduce_opt = "800m"

    
    $formatNN = "no"

    # HA configuration
    $qjm_ha_mode = "yes"
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

    #rack-aware configuration
    $rack_aware = "yes"
    
    # enable ganglia monitor configuration
    $ganglia_monitor = "yes"
    if $ganglia_monitor == "yes" {
        $gmetad_server = "NN-agent"
    }elsif $ganglia_monitor == "no"{
        $gmetad_server = undef
    }

    #$enable_capacity_scheduler = "yes"
    $scheduler_type = "fair" #fifo| capacity|fair
}

